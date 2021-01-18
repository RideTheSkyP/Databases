from django.urls import path
from . import views


urlpatterns = [
    path("", views.startPage, name="start"),
    path("home/", views.home, name="home"),
    path("login/", views.loginToAcc, name="login"),
    path("logout/", views.logoutFromAcc, name="logout"),
    path("signup/", views.signup, name="signup"),
    path("transfer/", views.transfer, name="transfer"),
    path("transactionsHistory/", views.transactionsHistory, name="transactionsHistory"),
    path("recoverGame/", views.recoverGame, name="recoverGame"),
    path("password/", views.changePassword, name='changePassword'),
    path("dumpDatabase/", views.dumpDatabase, name="dumpDatabase"),
    path("loadDatabase/", views.loadDatabase, name="loadDatabase"),
]
