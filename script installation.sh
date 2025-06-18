#!/bin/bash

# Créer l'architecture de dossiers
mkdir -p network_reconnaissance/static/css
mkdir -p network_reconnaissance/templates

# Créer le fichier app.py
cat > network_reconnaissance/app.py << 'EOL'
from flask import Flask, render_template
import subprocess

app = Flask(__name__)

def scan_network(network_range):
    result = subprocess.run(['nmap', '-sn', network_range], stdout=subprocess.PIPE)
    return result.stdout.decode('utf-8')

def detailed_scan(ip_address):
    result = subprocess.run(['nmap', '-O', '-sV', ip_address], stdout=subprocess.PIPE)
    return result.stdout.decode('utf-8')

def parse_nmap_output(output):
    devices = []
    lines = output.split('\n')
    for line in lines:
        if 'Nmap scan report for' in line:
            ip = line.split(' ')[-1]
            devices.append(ip)
    return devices

@app.route('/')
def index():
    network_range = '192.168.1.0/24'
    scan_output = scan_network(network_range)
    devices = parse_nmap_output(scan_output)

    device_details = {}
    for device in devices:
        device_details[device] = detailed_scan(device)

    return render_template('index.html', devices=devices, device_details=device_details)

if __name__ == '__main__':
    app.run(debug=True)
EOL

# Créer le fichier index.html dans le dossier templates
cat > network_reconnaissance/templates/index.html << 'EOL'
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Network Reconnaissance</title>
    <link rel="stylesheet" href="/static/css/style.css">
</head>
<body>
    <h1>Network Reconnaissance</h1>
    <div class="devices">
        {% for device in devices %}
        <div class="device">
            <h2>Device: {{ device }}</h2>
            <pre>{{ device_details[device] }}</pre>
        </div>
        {% endfor %}
    </div>
</body>
</html>
EOL

# Créer le fichier style.css dans le dossier static/css
cat > network_reconnaissance/static/css/style.css << 'EOL'
body {
    font-family: Arial, sans-serif;
    margin: 20px;
}

h1 {
    color: #333;
}

.device {
    background-color: #f4f4f4;
    margin: 10px 0;
    padding: 10px;
    border-radius: 5px;
}

pre {
    white-space: pre-wrap;
    word-wrap: break-word;
}
EOL

echo "L'architecture de fichiers et les scripts ont été cré
és avec succès."
