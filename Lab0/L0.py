import pandas as pd

chinook = pd.read_csv("chinook.csv", sep=";")

while True:
    entered = int(input("Please enter the number of exercise (1-6): "))

    if entered == 1:
        for artistId in chinook.ArtistId.unique():
            print(f"Artist: {chinook.Name[chinook.ArtistId == artistId].unique()} Albums: {chinook.Title[chinook.ArtistId == artistId].unique()}")
    elif entered == 2:
        var = chinook.Name == "Various Artists"
        print(f"Various Artists titles: {chinook.Title[var].unique()}")
    elif entered == 3:
        print("Songs which lasts 250000 milliseconds", chinook["Name.1"][chinook.Milliseconds > 250000].to_string(index=False))
    elif entered == 4:
        cd = (chinook["Name.2"] == "Comedy") | (chinook["Name.2"] == "Drama")
        print(f"Comedy and drama titles: {chinook.Title[cd].unique()}")
    elif entered == 5:
        price = float(max(chinook.UnitPrice[chinook["Name.2"] == "Rock"].unique()).replace(",", "."))
        titlesAmount = {}
        for artistId in chinook.ArtistId[chinook["Name.2"] == "Rock"].unique():
            titlesAmount[artistId] = len(chinook[chinook.ArtistId == artistId])

        for key, value in titlesAmount.items():
            if value is max(titlesAmount.values()):
                print(f"The artist who have the highest total price: {chinook.Name[chinook.ArtistId == value].to_string(index=False)}. The price is: {max(titlesAmount.values()) * price}")
    elif entered == 6:
        unknownComposer = chinook.Composer == r"\N"
        print(f"Rows with unknown composer:\n{chinook[unknownComposer]}")
