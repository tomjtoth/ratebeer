```sh
ratebeer(dev)> b = Brewery.create(name: "BrewDog", year: 2007)
  TRANSACTION (0.1ms)  BEGIN immediate TRANSACTION /*application='Ratebeer'*/
  Brewery Create (0.5ms)  INSERT INTO "breweries" ("name", "year", "created_at", "updated_at") VALUES ('BrewDog', 2007, '2025-03-29 09:24:43.652219', '2025-03-29 09:24:43.652219') RETURNING "id" /*application='Ratebeer'*/
  TRANSACTION (6.7ms)  COMMIT TRANSACTION /*application='Ratebeer'*/
=>
#<Brewery:0x00007f29dec41440
...
ratebeer(dev)> b
=>
#<Brewery:0x00007f29dec41440
 id: 4,
 name: "BrewDog",
 year: 2007,
 created_at: "2025-03-29 09:24:43.652219000 +0000",
 updated_at: "2025-03-29 09:24:43.652219000 +0000">
ratebeer(dev)> k1 = b.beers.create(name: "Punk IPA", style: "IPA")
  TRANSACTION (0.1ms)  BEGIN immediate TRANSACTION /*application='Ratebeer'*/
  Beer Create (0.4ms)  INSERT INTO "beers" ("name", "style", "brewery_id", "created_at", "updated_at") VALUES ('Punk IPA', 'IPA', 4, '2025-03-29 09:25:28.893192', '2025-03-29 09:25:28.893192') RETURNING "id" /*application='Ratebeer'*/
  TRANSACTION (0.1ms)  COMMIT TRANSACTION /*application='Ratebeer'*/
=>
#<Beer:0x00007f29de1ecdc8
...
ratebeer(dev)> k1
=>
#<Beer:0x00007f29de1ecdc8
 id: 8,
 name: "Punk IPA",
 style: "IPA",
 brewery_id: 4,
 created_at: "2025-03-29 09:25:28.893192000 +0000",
 updated_at: "2025-03-29 09:25:28.893192000 +0000">
ratebeer(dev)> k2 = b.beers.create(name: "Nanny State", style: "lowalcohol")
  TRANSACTION (0.1ms)  BEGIN immediate TRANSACTION /*application='Ratebeer'*/
  Beer Create (0.4ms)  INSERT INTO "beers" ("name", "style", "brewery_id", "created_at", "updated_at") VALUES ('Nanny State', 'lowalcohol', 4, '2025-03-29 09:25:56.503285', '2025-03-29 09:25:56.503285') RETURNING "id" /*application='Ratebeer'*/
  TRANSACTION (0.1ms)  COMMIT TRANSACTION /*application='Ratebeer'*/
=>
#<Beer:0x00007f29dd593720
...
ratebeer(dev)> k2
=>
#<Beer:0x00007f29dd593720
 id: 9,
 name: "Nanny State",
 style: "lowalcohol",
 brewery_id: 4,
 created_at: "2025-03-29 09:25:56.503285000 +0000",
 updated_at: "2025-03-29 09:25:56.503285000 +0000">
ratebeer(dev)> k1.ratings.create(score: 10)
  TRANSACTION (0.0ms)  BEGIN immediate TRANSACTION /*application='Ratebeer'*/
  Rating Create (0.3ms)  INSERT INTO "ratings" ("score", "beer_id", "created_at", "updated_at") VALUES (10, 8, '2025-03-29 09:26:11.009947', '2025-03-29 09:26:11.009947') RETURNING "id" /*application='Ratebeer'*/
  TRANSACTION (0.1ms)  COMMIT TRANSACTION /*application='Ratebeer'*/
=>
#<Rating:0x00007f29dd675d50
 id: 1,
 score: 10,
 beer_id: 8,
 created_at: "2025-03-29 09:26:11.009947000 +0000",
 updated_at: "2025-03-29 09:26:11.009947000 +0000">
ratebeer(dev)> k1.ratings.create(score: 20)
  TRANSACTION (0.1ms)  BEGIN immediate TRANSACTION /*application='Ratebeer'*/
  Rating Create (0.8ms)  INSERT INTO "ratings" ("score", "beer_id", "created_at", "updated_at") VALUES (20, 8, '2025-03-29 09:26:14.002626', '2025-03-29 09:26:14.002626') RETURNING "id" /*application='Ratebeer'*/
  TRANSACTION (0.1ms)  COMMIT TRANSACTION /*application='Ratebeer'*/
=>
#<Rating:0x00007f29dd569880
 id: 2,
 score: 20,
 beer_id: 8,
 created_at: "2025-03-29 09:26:14.002626000 +0000",
 updated_at: "2025-03-29 09:26:14.002626000 +0000">
ratebeer(dev)> k2.ratings.create(score: 30)
  TRANSACTION (0.1ms)  BEGIN immediate TRANSACTION /*application='Ratebeer'*/
  Rating Create (0.3ms)  INSERT INTO "ratings" ("score", "beer_id", "created_at", "updated_at") VALUES (30, 9, '2025-03-29 09:26:19.257446', '2025-03-29 09:26:19.257446') RETURNING "id" /*application='Ratebeer'*/
  TRANSACTION (0.1ms)  COMMIT TRANSACTION /*application='Ratebeer'*/
=>
#<Rating:0x00007f29dd56b040
 id: 3,
 score: 30,
 beer_id: 9,
 created_at: "2025-03-29 09:26:19.257446000 +0000",
 updated_at: "2025-03-29 09:26:19.257446000 +0000">
ratebeer(dev)> k2.ratings.create(score: 40)
  TRANSACTION (0.0ms)  BEGIN immediate TRANSACTION /*application='Ratebeer'*/
  Rating Create (0.3ms)  INSERT INTO "ratings" ("score", "beer_id", "created_at", "updated_at") VALUES (40, 9, '2025-03-29 09:26:21.122390', '2025-03-29 09:26:21.122390') RETURNING "id" /*application='Ratebeer'*/
  TRANSACTION (0.0ms)  COMMIT TRANSACTION /*application='Ratebeer'*/
=>
#<Rating:0x00007f29dd562e40
 id: 4,
 score: 40,
 beer_id: 9,
 created_at: "2025-03-29 09:26:21.122390000 +0000",
 updated_at: "2025-03-29 09:26:21.122390000 +0000">
ratebeer(dev)>

```
