import streamlit as st
import pandas as pd

st.set_page_config(layout="wide")

csv_file_path = '/home/elijah/beverage-analytics-project/data/raw'

# Load CSVs
df_sessions = pd.read_csv(csv_file_path + '/sessions.csv') 

def main():
    st.title('Edit Sessions')
        
    st.data_editor(df_sessions)

if __name__ == '__main__':
    main()