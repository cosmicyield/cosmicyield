import os
import re
import lizard

def audit_code(file_path):
    if not os.path.exists(file_path):
        print(f"Erreur : Le fichier {file_path} est introuvable.")
        return

    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Extraction du JavaScript entre les balises <script>
    scripts = re.findall(r'<script>(.*?)</script>', content, re.DOTALL)
    js_code = "\n".join(scripts)

    if not js_code:
        print("Aucun code JavaScript trouvé dans le fichier.")
        return

    # On utilise Lizard qui gère nativement le JavaScript et ses commentaires //
    with open("temp_audit.js", "w", encoding="utf-8") as temp_f:
        temp_f.write(js_code)
    
    # Analyse Lizard (donne CC, LOC et les fonctions)
    analysis = lizard.analyze_file("temp_audit.js")
    
    # Métriques
    loc = analysis.nloc  # Lignes de code réelles (sans commentaires/vides)
    avg_cc = analysis.average_cyclomatic_complexity
    gods = [f for f in analysis.function_list if f.nloc > 50]
    
    # Calcul d'un indice de maintenabilité simplifié (MI) basé sur CC et LOC
    # Formule simplifiée pour donner une tendance
    mi_score = max(0, 100 - (avg_cc * 3) - (loc / 100))
    mi_verdict = "✅ EXCELLENT" if mi_score > 80 else "⚠️ MOYEN" if mi_score > 60 else "🔴 CRITIQUE"
    
    os.remove("temp_audit.js")

    # AFFICHAGE DU TABLEAU
    print(f"\n--- AUDIT QUALITÉ : {file_path} ---")
    print(f"| Métrique    | Valeur   | Verdict          |")
    print(f"|-------------|----------|------------------|")
    print(f"| LOC (net)   | {loc:<8} | {('⚠️ Trop long' if loc > 2000 else '✅ OK'):<16} |")
    print(f"| CC (Moy)    | {avg_cc:<8.1f} | {('✅ CORRECT' if avg_cc < 10 else '⚠️ COMPLEXE'):<16} |")
    print(f"| Indice Main.| {mi_score:<8.1f} | {mi_verdict:<16} |")
    print(f"| God Methods | {len(gods):<8} | {('🔴 ' + str(len(gods)) if gods else '✅ AUCUNE'):<16} |")
    print(f"{'-'*45}")

    if gods:
        print("\nFonctions trop longues (>50 lignes) à surveiller :")
        # Tri des fonctions par longueur
        for g in sorted(gods, key=lambda x: x.nloc, reverse=True):
            print(f"- {g.name:<25} : {g.nloc:>4} lignes (CC: {g.cyclomatic_complexity})")

if __name__ == "__main__":
    audit_code('cosmic-yield-mainnet.html')