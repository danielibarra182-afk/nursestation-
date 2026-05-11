import json

try:
    with open('assets/data/medicamentos.json', 'r', encoding='utf-8') as f:
        data = json.load(f)
    print(f"JSON is valid. Found {len(data)} items.")
except Exception as e:
    print(f"Error: {e}")
