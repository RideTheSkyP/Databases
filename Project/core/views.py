from django.db import connection
from django.http import HttpResponse
from django.contrib.auth import login, authenticate, logout, update_session_auth_hash
from django.contrib.auth.forms import UserCreationForm, AuthenticationForm, PasswordChangeForm
from django.shortcuts import render, redirect
from django.contrib.auth.decorators import login_required
from django.forms.forms import BaseForm, Form
from django.contrib.auth.models import User
from django.utils.encoding import force_text
from django.utils.http import urlsafe_base64_decode
from django.utils.translation import ugettext_lazy as _
from django.core.management import call_command
from core.models import Player, PlayerStats
from pathlib import Path
from core.forms import SignUpForm
from django.contrib.auth.decorators import user_passes_test
from django.contrib import messages
from django.contrib.auth.models import User


BASE = Path(__file__).resolve().parent.parent
TEMPLATES = Path(BASE / "templates")


def startPage(request):
    return render(request, "base.html")


@login_required()
def home(request):
    data = 0
    access = ["Player", "Moderator", "Admin"]
    try:
        cursor = connection.cursor()
        cursor.execute("""SELECT privilege FROM core_player WHERE userId = %s""", [request.user.id])
        data = int(cursor.fetchall()[0][0])
    except Exception as exc:
        print(f"Home page database: {exc}")
    return render(request, "home.html", {"data": f"Yours privileges level is: {access[data]}"})


@user_passes_test(lambda u: u.is_anonymous, login_url="home")
def loginToAcc(request):
    if request.method == "POST":
        form = AuthenticationForm(data=request.POST)
        if form.is_valid():
            # form.save()
            username = form.cleaned_data.get("username")
            password = form.cleaned_data.get("password")
            user = authenticate(username=username, password=password)
            login(request, user)
            return redirect("home")
    else:
        form = AuthenticationForm()
    return render(request, "login.html", {"form": form})


@login_required()
def logoutFromAcc(request):
    logout(request)
    return redirect("start")


@login_required()
def statistics(request):
    print(request)


@login_required()
def transfer(request):
    try:
        cursor = connection.cursor()
        cursor.execute("""SELECT privilege FROM core_player WHERE userId = %s""", [request.user.id])
        data = cursor.fetchall()[0]
        if int(data[0]) < 1:
            return render(request, "home.html", {"data": f"You dont have access to modification the players stats"})
    except Exception as exc:
        print(f"Transfer page database: {exc}")

    if request.method == "POST":
        userId = request.POST.get("playerId")
        scoredPoints = request.POST.get("scoredPoints")
        averagePoints = request.POST.get("averagePoints")
        teamContribution = request.POST.get("teamContribution")
        gamesAmount = request.POST.get("gamesAmount")
        totalKills = request.POST.get("totalKills")
        totalAssists = request.POST.get("totalAssists")

        try:
            cursor = connection.cursor()
            cursor.execute("""SELECT userId = %s FROM core_playerstats""", [userId])
            data = cursor.fetchall()
            if not data:
                return render(request, "home.html", {"data": f"Player {userId} doesn't exist"})
        except Exception as exc:
            print(f"Transfer page post database: {exc}")

        transfers = PlayerStats(userId=userId, scoredPoints=scoredPoints, averagePoints=averagePoints,
                                teamContribution=teamContribution, gamesAmount=gamesAmount, totalKills=totalKills,
                                totalAssists=totalAssists)
        transfers.save()
        return render(request, "transactionComplete.html")
    return render(request, "bankForm.html")


@login_required()
def recoverGame(request):
    try:
        cursor = connection.cursor()
        cursor.execute("""SELECT privilege FROM core_player WHERE userId = %s""", [request.user.id])
        data = cursor.fetchall()[0]
        if int(data[0]) < 2:
            return render(request, "home.html", {"data": f"You dont have access to modification the players stats"})
    except Exception as exc:
        print(f"Transfer page database: {exc}")

    if request.method == "POST":
        playerId = request.POST.get("playerId")
        scoredPoints = request.POST.get("scoredPoints")
        averagePoints = request.POST.get("averagePoints")
        teamContribution = request.POST.get("teamContribution")
        gamesAmount = request.POST.get("gamesAmount")
        totalKills = request.POST.get("totalKills")
        totalAssists = request.POST.get("totalAssists")

        action = request.POST.get("action")
        if action == "banPlayerId":
            user = User.objects.filter(id=playerId)
            user.delete()
            return render(request, "home.html", {"data": f"User: {playerId} deleted from database"})
        elif action == "modifyPlayerStats":
            try:
                transfers = PlayerStats(userId=playerId, scoredPoints=scoredPoints, averagePoints=averagePoints,
                                        teamContribution=teamContribution, gamesAmount=gamesAmount,
                                        totalKills=totalKills, totalAssists=totalAssists)
                transfers.save()
                return render(request, "transactionComplete.html")
            except Exception as exc:
                print(f"Transfer page post database: {exc}")
                return render(request, "home.html", {"data": f"User: {playerId} doesn't exists"})
        elif action == "viewPlayerStats":
            cursor = connection.cursor()
            cursor.execute("""SELECT auth_user.id, auth_user.username, scoredPoints, averagePoints, teamContribution, gamesAmount, totalKills, totalAssists FROM core_playerstats INNER JOIN auth_user ON auth_user.id=userId WHERE userId=%s""", [playerId])
            form = cursor.fetchall()
            return render(request, "recovery.html", {"stats": form})
    return render(request, "recovery.html")


@login_required()
def dumpDatabase(request):
    try:
        cursor = connection.cursor()
        cursor.execute("""SELECT privilege FROM core_player WHERE userId = %s""", [request.user.id])
        data = cursor.fetchall()[0]
        if int(data[0]) < 2:
            return render(request, "home.html", {"data": f"You don't have access to dump the database"})
    except Exception as exc:
        print(f"Transfer page database: {exc}")

    dump = request.POST.get("dump")
    if dump:
        try:
            if dump == "dumpToJson":
                with open("dump.json", "w") as dumpFile:
                    call_command("dumpdata", format="json", indent=4, stdout=dumpFile)
                    dumpFile.close()
                    dump = "JSON"
            elif dump == "dumpToXml":
                with open("dump.xml", "w") as dumpFile:
                    call_command("dumpdata", format="xml", indent=4, stdout=dumpFile)
                    dumpFile.close()
                    dump = "XML"
            elif dump == "dumpToYaml":
                with open("dump.yaml", "w") as dumpFile:
                    call_command("dumpdata", format="yaml", indent=4, stdout=dumpFile)
                    dumpFile.close()
                    dump = "YAML"
            return render(request, "dumpDatabase.html", {"data": f"Dumped to {dump} successfully"})
        except Exception as e:
            print(e)
            return render(request, "dumpDatabase.html", {"data": f"Dump to {dump} haven't proceed"})
    return render(request, "dumpDatabase.html")


@login_required()
def loadDatabase(request):
    try:
        cursor = connection.cursor()
        cursor.execute("""SELECT privilege FROM core_player WHERE userId = %s""", [request.user.id])
        data = cursor.fetchall()[0]
        if int(data[0]) < 2:
            return render(request, "home.html", {"data": f"You don't have access to load the database"})
    except Exception as exc:
        print(f"Transfer page database: {exc}")

    dump = request.POST.get("dump")
    if dump:
        try:
            if dump == "dumpToJson":
                dump = "dump.json"
                call_command("loaddata", dump)
            elif dump == "dumpToXml":
                dump = "dump.xml"
                call_command("loaddata", dump)
            elif dump == "dumpToYaml":
                dump = "dump.yaml"
                call_command("loaddata", dump)
            return render(request, "loadDatabase.html", {"data": f"Dump: {dump}, loaded successfully"})
        except Exception as e:
            print(e)
            return render(request, "loadDatabase.html", {"data": f"Load database from: {dump}, haven't proceed"})
    return render(request, "loadDatabase.html")


@login_required()
def transactionsHistory(request):
    transactions = []
    for t in PlayerStats.objects.raw(f"select * from core_playerstats where userId={request.user.id}"):
        transactions.append([t.userId, t.scoredPoints, t.averagePoints, t.teamContribution, t.gamesAmount,
                             t.totalKills, t.totalAssists])
    return render(request, "transactionsHistory.html", {"transactions": transactions})


@user_passes_test(lambda u: u.is_anonymous, login_url="home")
def signup(request):
    if request.method == "POST":
        form = SignUpForm(request.POST)
        if form.is_valid():
            form.save()
            username = form.cleaned_data.get("username")
            password = form.cleaned_data.get("password1")
            user = authenticate(username=username, password=password)
            login(request, user)
            return redirect("home")
    else:
        form = SignUpForm()
    return render(request, "signup.html", {"form": form})


@login_required()
def changePassword(request):
    if request.method == 'POST':
        form = PasswordChangeForm(request.user, request.POST)
        if form.is_valid():
            user = form.save()
            update_session_auth_hash(request, user)
        return redirect("home")
    else:
        form = PasswordChangeForm(request.user)
    return render(request, "changePassword.html", {"form": form})

