# Cerințe de Sistem

## Monitorizarea parametrilor mediului
- Colectarea datelor despre temperatura aerului.
- Colectarea datelor despre umiditatea relativă a aerului.
- Colectarea datelor despre presiunea atmosferică.
- Colectarea datelor despre compușii volatili organici din aer.
- Colectarea datelor despre intensitatea luminii.
- Colectarea datelor despre intensitatea radiației ultraviolete.
- Colectarea datelor despre nivelul de zgomot.
- Colectarea datelor trebuie să fie efectuată cu o recurență stabilită.

## Configurarea recurenței eșantionării
- Utilizatorul poate regla frecvența eșantionării, cu o limită minimă de 1 minut și maxim de 1 oră.

## Persistența datelor
- Utilizarea unui chip de flash pentru stocarea datelor pe dispozitivul de monitorizare.
- Algoritm de nivelare a uzurii pentru prelungirea duratei de viață a flashului.
- Utilizarea unei baze de date SQLite pentru stocarea datelor în aplicația mobilă.
- Posibilitatea exportului datelor în formatele CSV, JSON, XML și SQLite.

## Configurarea alarmelor și notificărilor
- Configurarea alarmelor pentru diverse condiții prin intermediul aplicației mobile.
- Specificarea condițiilor pentru activarea alarmelor, inclusiv intervalul de valori și direcția (când intră sau iese din interval).
- Configurarea modului de notificare al alarmelor (sonor, vibrații, notificări push etc.).

## Emiterea de alerte și notificări
- Emisia de alerte pentru condițiile configurate de utilizator în aplicația mobilă.
- Furnizarea notificărilor sau widgeturilor cu datele colectate.
- Emiterea de alerte de către dispozitivul de monitorizare pentru condițiile configurate.

## Interfața grafică pentru vizualizarea datelor
- O interfață grafică intuitivă pentru vizualizarea datelor curente în aplicația mobilă.
- Vizualizarea evoluției parametrilor în timp prin intermediul graficelor.
- Posibilitatea de a alege parametrii afișați pe grafice și de a compara diferite seturi de date.

## Configurabilitate prin interfața grafică
- O interfață intuitivă pentru configurarea parametrilor sistemului.
- Configurarea recurenței eșantionării parametrilor.
- Crearea, activarea și dezactivarea alarmelor de către utilizator.