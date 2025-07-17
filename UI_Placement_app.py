import streamlit as st
import pandas as pd
import numpy as np
import mysql.connector
import plotly.express as px

# Set page config early
st.set_page_config(page_title="Placement Dashboard", layout="wide")

# Connect to the remote SQL database (TiDB Cloud)
conn = mysql.connector.connect(
    host="gateway01.ap-southeast-1.prod.aws.tidbcloud.com",
    user="4DTwJ2ZR7XTapss.root",
    password="veNd2wXPKzLZwbmt",
    port=4000
)
cursor = conn.cursor()
cursor.execute('USE Placement_Eligibility_App')

# Create two tabs
tab1, tab2 = st.tabs(["Main Dashboard", "Eligibility Filter"])

# ---------------- TAB 1: Dashboard ----------------
with tab1:
    st.title("💼 PLACEMENT ELIGIBILITY APP")

    with st.expander("📘 About the App"):
        st.image("C:/Users/Deepika Devi A/Downloads/placementseklec.png", use_container_width=True)
        st.write("""
            This Placement Dashboard helps track students' placement readiness and outcomes.
            It visualizes mock interview scores, internship experience, soft skills, and
            placement status in a clear and interactive way.
        """)

    # Get dashboard metrics
    cursor.execute("SELECT COUNT(*) FROM Students")
    total_students = cursor.fetchone()[0]

    cursor.execute("SELECT COUNT(DISTINCT company_name) FROM Placement WHERE company_name IS NOT NULL")
    total_companies = cursor.fetchone()[0]

    cursor.execute("SELECT AVG(placement_package) FROM Placement WHERE placement_package IS NOT NULL")
    avg_package = cursor.fetchone()[0]

    cursor.execute("SELECT placement_status, COUNT(*) FROM Placement GROUP BY placement_status")
    status_data = cursor.fetchall()

    # Show key metrics
    col1, col2, col3 = st.columns(3)
    col1.metric("👨‍🎓 Total Students", total_students)
    col2.metric("🏢 Total Companies", total_companies)
    col3.metric("💰 Avg. Package", f"₹{avg_package:,.2f}")

    # Pie chart for placement status
    if status_data:
        df_status = pd.DataFrame(status_data, columns=["Status", "Count"])
        fig = px.pie(df_status, names="Status", values="Count", title="Placement Status")
        st.plotly_chart(fig, use_container_width=True)
    else:
        st.warning("No placement status data found.")
    
    #Placement Status by Batch
    cursor.execute("""
        SELECT s.course_batch, pl.placement_status, COUNT(*) AS student_count
        FROM Students s
        JOIN Placement pl ON s.student_id = pl.student_id
        GROUP BY s.course_batch, pl.placement_status
    """)
    result = cursor.fetchall()
    df_status_batch = pd.DataFrame(result, columns=["Batch", "Status", "Count"])
    fig1 = px.bar(df_status_batch, x="Batch", y="Count", color="Status", barmode="stack",
                  title="Placement Status Count by Batch")
    st.plotly_chart(fig1, use_container_width=True)

    #Programming Language Popularity (horizontal bar)
    cursor.execute("""
        SELECT language, COUNT(*) AS student_count
        FROM Programming
        GROUP BY language
    """)
    result = cursor.fetchall()
    df_lang = pd.DataFrame(result, columns=["Language", "Students"])
    fig2 = px.bar(df_lang, x="Students", y="Language", orientation="h",
                  title="Programming Language Popularity")
    st.plotly_chart(fig2, use_container_width=True)

# ---------------- TAB 2: Eligibility Filter ----------------
with tab2:
    st.subheader("🎯 Filter by Eligibility Criteria")

    # Define filter options
    soft_skill_options = {
        "75-100": (75, 100),
        "50-74": (50, 74),
        "20-49": (20, 49)
    }
    problems_options = {
        "81-120": (81, 120),
        "50-80": (50, 80),
        "10-49": (10, 49)
    }
    mini_project_options = {
        "3-5": (3, 5),
        "2-3": (2, 3),
        "0-1": (0, 1)
    }
    assessment_options = {
        "8-10": (8, 10),
        "5-7": (5, 7),
        "0-4": (0, 4)
    }

    # Select boxes for filters
    soft_skill_range = st.selectbox("Soft Skill Average Range", list(soft_skill_options.keys()))
    problem_range = st.selectbox("Problems Solved Range", list(problems_options.keys()))
    mini_project_range = st.selectbox("Mini Projects Range", list(mini_project_options.keys()))
    assessment_range = st.selectbox("Assessments Completed Range", list(assessment_options.keys()))

    # Extract actual values
    ss_min, ss_max = soft_skill_options[soft_skill_range]
    prob_min, prob_max = problems_options[problem_range]
    mini_min, mini_max = mini_project_options[mini_project_range]
    assess_min, assess_max = assessment_options[assessment_range]

    # SQL Query with filters
    query = f"""
        SELECT 
            s.name, s.email,
            ROUND((
                ss.communication + ss.teamwork + ss.leadership + 
                ss.critical_thinking + ss.presentation + ss.interpersonal_skills
            ) / 6, 2) AS soft_skill_avg,
            pg.problems_solved,
            pg.mini_projects,
            pg.assessments_completed,
            pl.placement_status
        FROM Students s
        JOIN SoftSkills ss ON s.student_id = ss.student_id
        JOIN Programming pg ON s.student_id = pg.student_id
        JOIN Placement pl ON s.student_id = pl.student_id
        HAVING soft_skill_avg BETWEEN {ss_min} AND {ss_max}
           AND problems_solved BETWEEN {prob_min} AND {prob_max}
           AND mini_projects BETWEEN {mini_min} AND {mini_max}
           AND assessments_completed BETWEEN {assess_min} AND {assess_max}
    """

    try:
        df = pd.read_sql(query, conn)
        if not df.empty:
            st.success("✅ Eligible Students")
            st.dataframe(df)
        else:
            st.warning("No students found matching the selected criteria.")
    except Exception as e:
        st.error(f"Error running the query: {e}")

# Close connection at the very end
conn.close()