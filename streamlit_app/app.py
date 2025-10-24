import streamlit as st
import pandas as pd
import numpy as np
import uuid

st.set_page_config(page_title="Beverage Web App", page_icon=":tea:", layout="centered", initial_sidebar_state="auto")

st.sidebar.image('img/bev.jpg', width="stretch")
activity = ["Log Brew", "Add Product", "Add Vendor", "Add Order"]
choice = st.sidebar.selectbox("Menu", activity)

csv_file_path = "/Users/elijahsilva/projects/beverage-analytics-project/data/raw"

# Load CSVs
df_products = pd.read_csv(csv_file_path + "/products.csv")  # columns: product_name, vendor_name
df_order_items = pd.read_csv(csv_file_path + "/order_items.csv")  # columns: product_name, product_date, order_number
df_orders = pd.read_csv(csv_file_path + "/orders.csv")  # columns: vendor_name, order_number

# Merge to get vendor_name for each order_item
df = df_order_items.merge(df_orders, on="order_number", how="left") \
    .merge(df_products, on="product_name", how="left")

# Now take distinct combinations
reference_table = (df[["product_name", "product_type_name", "vendor_name_x", "production_date"]].drop_duplicates()
                   .sort_values(["product_type_name", "product_name", "vendor_name_x", "production_date"]).reset_index(
    drop=True)
                   .rename(columns={'product_name': 'name',
                                    'product_type_name': 'type',
                                    'vendor_name_x': 'vendor',
                                    'production_date': 'production date', })
                   )

for name in ["sessions", "products", "session_batch_inventory",
             "extractions", "order_items"]:
    if name not in st.session_state:
        st.session_state[name] = pd.read_csv(f"{csv_file_path}/{name}.csv")

st.title("Beverage Web App")

def main():
    if choice == "Log Brew":

        st.header('Log Brew')

        if 'session_code' not in st.session_state:
            st.session_state.session_code = uuid.uuid4()

        st.subheader('General Information')

        st.info(f'Session code: {st.session_state.session_code}')


        col1, col2, col3 = st.columns(3)


        with col1:

            rating = st.slider("Rating", min_value=0, step=1, max_value=10)
            favorite_flag = st.checkbox("Favorite Flag")

            water_type = st.radio(
                "Water Type",
                ("Filtered", "Tap", "Spring"),
                index=None
            )
            session_type = st.radio(
                "Session Type",
                ("Coffee", "Tea"),
                index=None,
            )

        with col2:
            session_date = st.date_input("Session Date", format="YYYY-MM-DD")
            session_time = st.time_input("Session Time")
            session_datetime = str(session_date) + " " + str(session_time)
            session_location_name = st.selectbox(
                "Session Location Name",
                ("House", "Shop", "Outdoors", "Work", "Ceremonial"),
                index=None,
                placeholder="Select session location...",
            )

            location_name = st.selectbox(
                "Session Location Name",
                ("Quebec Ave", "Mom's"),
                index=None,
                placeholder="Select location...",
            )


        with col3:
            brew_method = st.selectbox(
                "Brew Method",
                ("Espresso", "Western", "Gongfu", "Grandpa", "Kyusu", "Cold Brew", "Matcha", "Filter", "Moka", "Pour Over"),
                index=None,
                placeholder="Select brew method...",
            )
            grind_size = st.number_input("Grind Size", min_value=0.0, max_value=30.0, step=0.1, format="%0.1f")
            extraction_number = 1
            extraction_time = st.number_input("Extraction Time", min_value=0, step=1, max_value=10000)

            water_temperature = st.number_input("Water Temperature", min_value=0, step=1, max_value=100)

        st.subheader("Notes")

        session_notes = st.text_area("Session Notes", "", height=100)
        extraction_notes = st.text_area("Extraction Notes", "", height=100)

        ingredient_ref_table = reference_table[reference_table['type'].isin(['Tea', 'Coffee'])].sort_values(['type', 'name'])

        st.subheader('Ingredient')

        with st.expander("Show current ingredients:"):
            st.write(ingredient_ref_table)

        col1, col2 = st.columns(2)

        with col1:
            ingredient_name = st.selectbox(
                "Product Name",
                ingredient_ref_table['name'].unique().tolist(),
                index=None,
                placeholder="Select product..."
            )
            ingredient_vendor_name = st.selectbox(
                "Vendor Name",
                ingredient_ref_table['vendor'].unique().tolist(),
                index=None,
                placeholder="Select vendor..."
            )
            production_date = st.date_input("Production Date", min_value="1990-01-01", format="YYYY-MM-DD")

        with col2:
            quantity_in = st.text_input("Quantity Used")
            quantity_output = st.text_input("Quantity Out")
            role_ingredient = st.selectbox(
                "Role",
                ("Espresso Dose", "Tea Dose"),
                index=None,
                placeholder="Select dose type..."
            )

        new_ingredient_rows = pd.DataFrame([{
            "session_code": st.session_state.session_code,
            "product_name": ingredient_name,
            "vendor_name": ingredient_vendor_name,
            "production_date": production_date,
            "quantity_used": quantity_in,
            "quantity_output": quantity_output,
            "role": role_ingredient,
            "batch_code": np.nan,
            "unit": "g"
        }])

        equip_ref_table = reference_table[reference_table['type'] == 'Equipment'].drop(columns=['production date', 'type'])

        st.subheader('Equipment')

        # --- Initialize session state ---
        if "equip_ref_table" not in st.session_state:
            st.session_state.equip_ref_table = equip_ref_table

        if "entries" not in st.session_state:
            st.session_state.entries = []  # <-- this line prevents that AttributeError

        # --- UI ---
        with st.expander("Show current equipment:"):
            st.write(st.session_state.equip_ref_table)


        def add_entry():
            st.session_state.entries.append({
                "product_name": None,
                "vendor_name": None,
                "role": None
            })

        def remove_entry():
            st.session_state.entries.pop()


        # --- Dynamic input rows ---
        tbl = st.session_state.equip_ref_table
        product_options = tbl["name"].unique().tolist()
        vendor_options = tbl["vendor"].unique().tolist()

        for i, entry in enumerate(st.session_state.entries):
            st.markdown(f"### Equipment {i + 1}")

            col1, col2, col3 = st.columns(3)

            with col1:
                entry["product_name"] = st.selectbox(
                    "Product Name",
                    product_options,
                    index=0,
                    key=f"product_{i}"
                )

            with col2:
                entry["vendor_name"] = st.selectbox(
                    "Vendor Name",
                    vendor_options,
                    index=0,
                    key=f"vendor_{i}"
                )

            with col3:
                entry["role"] = st.selectbox(
                    "Role",
                    ("Accessories", "Cup", "Kettle", "Teapot", "Gongfu", "Faircup", "Espresso Maker"),
                    index=0,
                    key=f"role_{i}"
                )

        new_equipment_rows = pd.DataFrame(st.session_state.entries)

        # insert first column at position 0
        new_equipment_rows.insert(0, "session_code", st.session_state.session_code,)

        # for remaining columns, safest is to just assign them
        new_equipment_rows["production_date"] = np.nan
        new_equipment_rows["quantity_used"] = 1
        new_equipment_rows["quantity_output"] = np.nan
        new_equipment_rows["batch_code"] = np.nan
        new_equipment_rows["unit"] = "pcs"

        # optionally reorder columns
        cols_order = [
            "session_code", "product_name", "vendor_name", "production_date",
            "quantity_used", "quantity_output", "batch_code", "unit", "role"
        ]
        new_equipment_rows = new_equipment_rows.reindex(columns=cols_order)

        new_sbi_rows = pd.concat([new_ingredient_rows, new_equipment_rows])

        # Add button
        col1, col2 = st.columns(2)

        with col1:
            st.button("Add Equipment", on_click=add_entry, width="stretch")

        with col2:
            st.button("Remove Equipment", on_click=remove_entry, width="stretch")

        st.write('-------------')

        if st.button("Add new rows to csv files", width="stretch", type="primary"):
            new_session_row = pd.DataFrame([[st.session_state.session_code,
                                             brew_method,
                                             rating,
                                             water_type,
                                             session_type,
                                             session_datetime,
                                             favorite_flag,
                                             session_location_name,
                                             location_name,
                                             grind_size,
                                             session_notes]],
                                           columns=st.session_state["sessions"].columns)
            st.session_state["sessions"] = pd.concat([st.session_state["sessions"], new_session_row], ignore_index=True)
            st.session_state["sessions"].to_csv(f"{csv_file_path}/sessions.csv", index=False)
            st.success("Session row added!")

            new_extraction_row = pd.DataFrame([[st.session_state.session_code,
                                                extraction_number,
                                                extraction_time,
                                                water_temperature,
                                                extraction_notes]],
                                              columns=st.session_state["extractions"].columns)
            st.session_state["extractions"] = pd.concat([st.session_state["extractions"], new_extraction_row],
                                                        ignore_index=True)
            st.session_state["extractions"].to_csv(f"{csv_file_path}/extractions.csv", index=False)
            st.success("Extraction row added!")

            st.session_state["session_batch_inventory"] = pd.concat([st.session_state["session_batch_inventory"], new_sbi_rows],
                                                        ignore_index=True)
            st.session_state["session_batch_inventory"].to_csv(f"{csv_file_path}/session_batch_inventory.csv", index=False)
            st.success("Session batch inventory rows added!")

    if choice == "Add Product":
        st.header('Add Product')
        st.write("In development...")

if __name__ == "__main__":
    main()