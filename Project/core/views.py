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
from core.models import Transfers
from pathlib import Path
from core.forms import SignUpForm
from django.contrib.auth.decorators import user_passes_test
from django.contrib import messages


BASE = Path(__file__).resolve().parent.parent
TEMPLATES = Path(BASE / "templates")


def startPage(request):
    return render(request, "base.html")


@login_required()
def home(request):
    money = 50000
    for transaction in Transfers.objects.raw(f"select * from core_transfers where userId={request.user.id}"):
        money = transaction.money

    accountNumber = request.user.id * 1321241212
    data = {"money": money, "accountNumber": accountNumber}
    return render(request, "home.html", context=data)


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
    if request.method == "POST":
        userId = request.user.id
        transferFrom = request.POST.get("transferfrom")
        transferTo = request.POST.get("transferto")
        amount = float(request.POST.get("amount"))
        save = request.POST.get("save")

        money = 50000
        for transaction in Transfers.objects.raw(f"select * from core_transfers where userId={request.user.id}"):
            money = float(transaction.money)

        if (transferTo == transferFrom) or (int(transferFrom) != int(request.user.id) * 1321241212) \
                or (save != "true") or (amount > money):
            return redirect("home")
        else:
            transfers = Transfers(userId=userId, transferFrom=transferFrom, transferTo=transferTo, amount=amount, money=money-amount)
            transfers.save()
            return render(request, "transactionComplete.html")

    return render(request, "bankForm.html")


@login_required()
def transactionsHistory(request):
    transactions = []
    for t in Transfers.objects.raw(f"select * from core_transfers where userId={request.user.id}"):
        transactions.append([t.transferFrom, t.transferTo, t.amount, t.money])
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

