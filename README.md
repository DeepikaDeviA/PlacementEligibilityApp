# PlacementEligibilityApp
This project is an interactive Streamlit web application designed to help placement teams and students analyze eligibility for job placements. It enables filtering students based on key performance metrics like programming skills, soft skills, internship experience, and interview performance.

# Description
The Placement Eligibility App is a simple and interactive dashboard made to help GUVI track how ready students are for placements. It shows important information like soft skills, coding performance, mock interview scores, and placement status.
The app includes a filter where users can choose criteria (like soft skill average, number of mini projects, etc.) to find eligible students easily.
It connects to a MySQL (TiDB Cloud) database with 4 linked tables. The data is created using the Faker and random libraries. The dashboard is built using Streamlit, and charts are shown using Plotly to make the data easy to understand.

# Getting Started
# Dependencies

- **Operating System:** Windows 11
- **Python Version:** 3.13
- **Libraries Required:**
  - streamlit
  - pandas
  - mysql-connector-python
  - plotly
  - faker
  - random

# Installing

**Clone this repository:**
 bash
 git clone https://github.com/DeepikaDeviA/PlacementEligibilityApp.git
 cd PlacementEligibilityApp
- Create a MySQL (or TiDB Cloud) database
- Run the table creation and data generation code
- You can also use CaseStudy.sql to run pre-defined queries and insights

# Executing program
Run the Streamlit App
- streamlit run UI_Placement_App.py

Navigate to the Main Dashboard tab to view:
- Total students, companies, average package
- Placement status chart
- Programming trends and batch-wise data

Switch to the Eligibility Filter tab to:
- Filter students based on selected criteria
- View placement status of filtered students

# Help
- Ensure your database connection is active
- If database not found, verify database/table creation

# Authors
Deepika Devi A
- GitHub: @DeepikaDeviA

# Version History
# v1.0 - Initial Release
Added full database setup, UI filters, and business insights

# License
This project is licensed under the MIT License - see the LICENSE.md file for details.

# Acknowledgments
I’d like to thank the following for their support and inspiration throughout this project:

- **GUVI** for the project idea and learning resources.
- **Faker** and **Random** libraries for mock data generation.
- **Streamlit** for making interactive UI development simple.
- **Plotly Express** for easy and beautiful data visualizations.
- Inspiration and structure taken from:
- **DomPizzie's README Template** (https://gist.github.com/DomPizzie/7a5ff55ffa9081f2de27c315f5018afc) – for providing a clean and well-structured README format.