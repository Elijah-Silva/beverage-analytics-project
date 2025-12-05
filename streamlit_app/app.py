import streamlit as st

create_page = st.Page('create.py', title='Create entry')
sessions_page = st.Page('sessions.py', title='Edit sessions')

pg = st.navigation([create_page, sessions_page])
pg.run()
