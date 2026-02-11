# Projet : Jeu 3D Godot – Crosshair et interactions 3D

- Description : petit jeu 3D en Godot où le joueur est dans un lobby, peut lancer une partie via des boutons 3D cliquables avec un crosshair, puis revenir au lobby avec un système de succès affichés physiquement sur un mur.
- Discussion avec l’IA (ChatGPT) sur le système de crosshair + RayCast3D :
  - https://chatgpt.com/share/698a63ce-585c-8011-bef5-f94dc612344b
- Capture du projet : <img width="1155" height="652" alt="image" src="https://github.com/user-attachments/assets/75d45a84-bc21-440b-8143-22663f1acca7" />


---

## Veille – Godot / Développement de jeux 3D

### Flux RSS suivis (validés)
1. Godot Engine — Blog officiel : https://godotengine.org/rss.xml
2. Rust — Blog : https://blog.rust-lang.org/feed.xml
3. KidsCanCode — Blog Godot : https://kidscancode.org/blog/index.xml
4. Open Source Game Clones : https://osgameclones.com/feed.xml
5. Game Developer (ex-Gamasutra) – News : https://www.gamedeveloper.com/rss.xml

### Communautés
- Discord : Godot Engine Official — https://discord.gg/godotengine
- Reddit : r/godot — https://www.reddit.com/r/godot/
- X / Twitter : @godotengine — https://x.com/godotengine
- Forum : Godot Engine Forum — https://forum.godotengine.org/
- Blog : GDQuest — https://www.gdquest.com/
- YouTube : GDQuest — https://www.youtube.com/c/Gdquest

### Collection Raindrop.io
- Collection : Veille Godot / Game Dev
- Flux RSS public de la collection : https://bg.raindrop.io/rss/public/66679972

---

## Automatisation 1 — RSS → Email + Google Sheet (Make)
- Flux surveillés : voir “Flux RSS suivis” ci-dessus
- Filtrage : mots-clés sur titre/texte — godot, release, tutorial, shader, 3d
- Mapping Google Sheet : Date (pubDate), Titre (title), Résumé (HTML→texte), Lien (link)
- Email : Sujet [Veille] {{title}} ; Corps = Titre, Date, Résumé, Lien
- Planification : toutes les <X h> (America/Toronto)
- Google Sheet (lecture publique) : https://docs.google.com/spreadsheets/d/1EeZpwd-shhJwurL5CmJma-J3kTDUYjfENYzim0KdgTE/edit?usp=sharing

## Automatisation 2 — Agrégateur start.me
- Page publique : https://start.me/p/192Bb9/utiliser-l-aggregateur-https-start-me-pour-re
- Widgets présents :
  - 1 boîte “Communautés” (voir la liste ci-dessus)
  - ≥ 2 widgets RSS (choisis parmi les flux ci-dessus)
  - 1 widget RSS Raindrop (URL ci-dessus)
  - 1 widget “Page web” (ex. https://docs.godotengine.org/en/stable/)
  - 3 widgets “Notes” (cheat‑sheet techniques)
