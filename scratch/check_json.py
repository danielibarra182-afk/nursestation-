import json
import sys

try:
    with open(r'c:\Users\Usuario\med_app\assets\data\medicamentos.json', 'r', encoding='utf-8') as f:
        json.load(f)
    print("JSON is valid")
except json.JSONDecodeError as e:
    print(f"JSON Error: {e}")
except Exception as e:
    print(f"Error: {e}")
