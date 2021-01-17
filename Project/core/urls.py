from django.template.defaulttags import url
from django.urls import path, include
from . import views
from django.contrib.auth import views as djangoViews
from django.contrib.auth import urls as djangoUrls

urlpatterns = [
    path("", views.startPage, name="start"),
    path("home/", views.home, name="home"),
    path("login/", views.loginToAcc, name="login"),
    path("logout/", views.logoutFromAcc, name="logout"),
    path("signup/", views.signup, name="signup"),
    # path("statistics/", views.statistics, name="statistics"),
    path("transfer/", views.transfer, name="transfer"),
    path("transactionsHistory/", views.transactionsHistory, name="transactionsHistory"),
    path("password/", views.changePassword, name='changePassword'),
    # path(r"^activate/(?P<uidb64>[0-9A-Za-z_\-]+)/(?P<token>[0-9A-Za-z]{1,13}-[0-9A-Za-z]{1,20})/$", views.activate, name='activate'),
    # path("password_reset/", djangoViews.PasswordResetView.as_view(), name='password_reset'),
    # path("password_reset/done/", djangoViews.PasswordResetDoneView, name='password_reset_done'),
    # path(r"password_reset_confirm/<uidb64>/<token>/", djangoViews.PasswordResetConfirmView, name='password_reset_confirm'),


    # path('password_reset/', djangoViews.PasswordResetView.as_view(), name='password_reset'),
    # path('password_reset/done/', djangoViews.PasswordResetDoneView.as_view(), name='password_reset_done'),
    # path('reset/<uidb64>/<token>/', djangoViews.PasswordResetConfirmView.as_view(), name='password_reset_confirm'),
    # path('reset/done/', djangoViews.PasswordResetCompleteView.as_view(), name='password_reset_complete')
]
