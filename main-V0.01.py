import nmap

print("Vyber-box\n")

# Choisir le type de scan
rep = input("Type de scan : [1] Scan réseau [2] Scan IP ")

if rep == "1":
    print("Démarrage scan réseau")
    nm = nmap.PortScanner()
    nm.scan(hosts='192.168.10.0/24', arguments='-n --spoof-mac 0')  # Scan du réseau en mode découverte

    # Affichage de tous les hôtes trouvés
    print("Hosts trouvés par Nmap :", nm.all_hosts())

    for host in nm.all_hosts():
        # Vérification de l'état de l'hôte et des protocoles disponibles
        if 'hostnames' in nm[host]:
            print(f"Hôte : {host} - {nm[host].hostname()}")
        else:
            print(f"Hôte : {host} - Nom : Inconnu")

        # Affichage des protocoles ouverts
        protocols = nm[host].all_protocols()
        if protocols:
            print(f"Protocoles ouverts pour {host} : {protocols}")
            for protocol in protocols:
                ports = nm[host][protocol].keys()
                for port in ports:
                    print(f"Port {port} ouvert")
        else:
            print(f"Aucun protocole ouvert trouvé pour {host}")

elif rep == "2":
    ip_cible = input("Entrez l'IP à scanner : ")
    print(f"Démarrage scan de l'IP : {ip_cible}")
    nm = nmap.PortScanner()
    nm.scan(hosts=ip_cible, arguments='-sS')  # Scan des ports ouverts avec un scan SYN

    if ip_cible in nm.all_hosts():
        print(f"Scan de l'IP {ip_cible} terminé")
        for protocol in nm[ip_cible].all_protocols():
            print(f"Protocol : {protocol}")
            ports = nm[ip_cible][protocol].keys()
            for port in ports:
                print(f"Port {port} ouvert")
    else:
        print(f"Pas de réponse de {ip_cible}")

else:
    print("Option non valide.")
