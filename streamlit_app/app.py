import streamlit as st
import pandas as pd
import numpy as np
import uuid

st.title('Log brew')

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

session_code = "TEST"  # uuid.uuid4()
# st.write(f"Session Code: {session_code}")

brew_method = st.selectbox(
    "Brew Method",
    ("Espresso", "Western"),
    index=None,
    placeholder="Select brew method name...",
)
rating = st.number_input("Rating", min_value=0, step=1, max_value=10)
water_type = st.selectbox(
    "Water Type",
    ("Filtered", "Tap"),
    index=None,
    placeholder="Select water type...",
)
session_type = st.selectbox(
    "Session Type",
    ("Coffee", "Tea"),
    index=None,
    placeholder="Select session type...",
)
session_date = st.date_input("Session Date", format="YYYY-MM-DD")
favorite_flag = st.checkbox("Favorite Flag")
session_location_name = st.selectbox(
    "Session Location Name",
    ("Home", "Cafe", "Outdoors"),
    index=None,
    placeholder="Select session location...",
)
location_name = st.selectbox(
    "Session Location Name",
    ("Home", "Moms"),
    index=None,
    placeholder="Select location...",
)
grind_size = st.number_input("Grind Size", min_value=0, step=1, max_value=30)
session_notes = st.text_area("Notes", "", height=100)

extraction_number = 1
extraction_time = st.number_input("Extraction Time", min_value=0, step=1, max_value=10000)
water_temperature = st.number_input("Water Temperature", min_value=0, step=1, max_value=100)
extraction_notes = st.text_area("Extraction Notes", "", height=100)

ingredient_ref_table = reference_table[reference_table['type'].isin(['Tea', 'Coffee'])].sort_values(['type', 'name'])

st.header('Ingredient Used:')

with st.expander("See current inventory"):
    st.write(ingredient_ref_table)

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
quantity_in = st.text_input("Quantity Used")
quantity_output = st.text_input("Quantity Out")
role_ingredient = st.selectbox(
    "Role",
    ("Espresso Dose", "Tea Dose"),
    index=None,
    placeholder="Select dose type..."
)

new_ingredient_rows = pd.DataFrame([{
    "session_code": session_code,
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

st.header('Equipment Used:')

# --- Initialize session state ---
if "equip_ref_table" not in st.session_state:
    st.session_state.equip_ref_table = equip_ref_table

if "entries" not in st.session_state:
    st.session_state.entries = []  # <-- this line prevents that AttributeError

# --- UI ---
with st.expander("See current inventory"):
    st.write(st.session_state.equip_ref_table)


def add_entry():
    st.session_state.entries.append({
        "product_name": None,
        "vendor_name": None,
        "role": None
    })


# --- Dynamic input rows ---
tbl = st.session_state.equip_ref_table
product_options = tbl["name"].unique().tolist()
vendor_options = tbl["vendor"].unique().tolist()

for i, entry in enumerate(st.session_state.entries):
    st.markdown(f"### Equipment {i + 1}")
    entry["product_name"] = st.selectbox(
        "Product Name",
        product_options,
        index=0,
        key=f"product_{i}"
    )
    entry["vendor_name"] = st.selectbox(
        "Vendor Name",
        vendor_options,
        index=0,
        key=f"vendor_{i}"
    )
    entry["role"] = st.selectbox(
        "Role",
        ("Accessories", "Cup"),
        index=0,
        key=f"role_{i}"
    )

new_equipment_rows = pd.DataFrame(st.session_state.entries)

# insert first column at position 0
new_equipment_rows.insert(0, "session_code", session_code)

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
st.button("Add Equipment", on_click=add_entry)

# Button to add a new row
st.header('Add row to csv')

if st.button("Add Row"):
    new_session_row = pd.DataFrame([[session_code,
                                     brew_method,
                                     rating,
                                     water_type,
                                     session_type,
                                     session_date,
                                     favorite_flag,
                                     session_location_name,
                                     location_name,
                                     grind_size,
                                     session_notes]],
                                   columns=st.session_state["sessions"].columns)
    st.session_state["sessions"] = pd.concat([st.session_state["sessions"], new_session_row], ignore_index=True)
    st.session_state["sessions"].to_csv(f"{csv_file_path}/sessions.csv", index=False)
    st.success("Session row added!")

    new_extraction_row = pd.DataFrame([[session_code,
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

# st.dataframe(st.session_state["sessions"])
# st.dataframe(st.session_state["extractions"])
