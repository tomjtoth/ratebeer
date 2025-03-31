# Kuvaus

Tämä on HY:n [Ruby on Rails kurssin](https://github.com/mluukkai/WebPalvelinohjelmointi2023) palautusrepo. Tuotantoversio pyörii [tässä](https://ratebeer-ttj.fly.dev)

## Apu tarkastajille

Kurssimateriaalin mukainen rails:in versio 7.0.4 ajama `rails new ratebeer` komento jäi jumiin, joten jouduin version 8.0.0 käyttää:

```sh
rbenv install 3.2.0
rbenv global 3.2.0
gem install rails -v 8.0.0
```

Muutamaa poikkeusta olen jo huomannut (kurssimateriaalin esimerkkeihin verrattuna), mutten mitään olennaista.

- viikon 4 GHA kohtaiset tehtävät oli (railsin version 8 takia kai) alusta asti valmiina, piti vaan hienosäätää
- myös viikon 4 Fly.io deplaus on ollut eka viikon lopusta asti käytössä
