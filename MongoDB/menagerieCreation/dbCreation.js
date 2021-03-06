help;
// Show databases
show dbs;
// Create database
use menagerie;
// Create collections
db.createCollection("pet");
db.createCollection("event");
show collections;

db.pet.insert([
 {
   "name": "Fluffy",
   "owner": "Harold",
   "species": "cat",
   "sex": "f",
   "birth": "1993-02-04",
   "death": null
 },
 {
   "name": "Claws",
   "owner": "Gwen",
   "species": "cat",
   "sex": "m",
   "birth": "1994-03-17",
   "death": null
 },
 {
   "name": "Buffy",
   "owner": "Harold",
   "species": "dog",
   "sex": "f",
   "birth": "1989-05-13",
   "death": null
 },
 {
   "name": "Fang",
   "owner": "Benny",
   "species": "dog",
   "sex": "m",
   "birth": "1990-08-27",
   "death": null
 },
 {
   "name": "Bowser",
   "owner": "Diane",
   "species": "dog",
   "sex": "m",
   "birth": "1979-08-31",
   "death": "1995-07-29"
 },
 {
   "name": "Chirpy",
   "owner": "Gwen",
   "species": "bird",
   "sex": "f",
   "birth": "1998-09-11",
   "death": null
 },
 {
   "name": "Whistler",
   "owner": "Gwen",
   "species": "bird",
   "sex": null,
   "birth": "1997-12-09",
   "death": null
 },
 {
   "name": "Slim",
   "owner": "Benny",
   "species": "snake",
   "sex": "m",
   "birth": "1996-04-29",
   "death": null
 }
]);

db.pet.insert([{
   "name": "Puffball",
   "owner": "Diane",
   "species": "hamster",
   "sex": "f",
   "birth": "1999-03-30",
   "death": null
 }
]);

db.event.insert([
 {
   "name": "Fluffy",
   "date": "1995-05-15",
   "type": "litter",
   "remark": "4 kittens, 3 female, 1 male"
 },
 {
   "name": "Buffy",
   "date": "1993-06-23",
   "type": "litter",
   "remark": "5 puppies, 2 female, 3 male"
 },
 {
   "name": "Buffy",
   "date": "1994-06-19",
   "type": "litter",
   "remark": "3 puppies, 3 female"
 },
 {
   "name": "Chirpy",
   "date": "1999-03-21",
   "type": "vet",
   "remark": "needed beak straightened"
 },
 {
   "name": "Slim",
   "date": "1997-08-03",
   "type": "vet",
   "remark": "broken rib"
 },
 {
   "name": "Bowser",
   "date": "1991-10-12",
   "type": "kennel",
   "remark": ""
 },
 {
   "name": "Fang",
   "date": "1991-10-12",
   "type": "kennel",
   "remark": ""
 },
 {
   "name": "Fang",
   "date": "1998-08-28",
   "type": "birthday",
   "remark": "Gave him a new chew toy"
 },
 {
   "name": "Claws",
   "date": "1998-03-17",
   "type": "birthday",
   "remark": "Gave him a new flea collar"
 },
 {
   "name": "Whistler",
   "date": "1998-12-09",
   "type": "birthday",
   "remark": "First birthday"
 }
]);
