use menagerie;
db.pet.find();
db.event.find();
//1
show collections;
//2
db.pet.find({}, {owner:1, name:1, _id:0});
//3
db.pet.find({species:"dog"}, {name:1, _id:0});
//4
db.pet.aggregate([
    { "$set": {
        "birth": {
            "$toDate": "$birth"
        }
    }},
    {$out: "pet"}]);

db.pet.find({ "$expr": { "$lte": [{ "$month": "$birth" }, 6] } })
//5
db.pet.find({sex: "m"}, {species:1, _id:0})
//6
db.event.find({type: "birthday"}, {name:1, date:1, _id:0})
db.event.find({type: "birthday", remark: {$regex: /^Gave/}}, {name:1, date:1, _id:0})
//7
db.pet.find({name: {$regex: /ffy$/}}, {name:1, owner:1, _id:0})
//8
db.pet.find({death: null}, {name:1, owner:1, _id:0});
//9
db.pet.aggregate({
    $group: {
        _id: {
            owner:"$owner"
        },
        count:{
            $sum: 1
        }}});
//10
db.event.aggregate([{
    $lookup: {
        from: "pet",
        localField: "name",
        foreignField: "name",
        as: "p"
    }}])

db.pet.aggregate([{
    $lookup:{
        from: "event",
        localField: "name",
        foreignField: "name",
        as: "e"
        }}])
