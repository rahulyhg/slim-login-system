<?php

use \App\Middleware\AuthMiddleware;
use \App\Middleware\GuestMiddleware;

$app->get('/', 'HomeController:index')->setName('home');

$app->group('', function () {

    $this->get('/auth/signup', 'AuthController:getSignUp')->setName('auth.signup');

    $this->post('/auth/signup', 'AuthController:postSignUp');

    $this->get('/auth/signin', 'AuthController:getSignIn')->setName('auth.signin');

    $this->post('/auth/signin', 'AuthController:postSignIn');

    // can add additional routes here if the user has to be signed in to access them

})->add(new GuestMiddleware($container));

// create route group - add middleware to the group - gotta be signed in to access

$app->group('', function (){

    $this->get('/auth/signout', 'AuthController:getSignOut')->setName('auth.signout');

    $this->get('/auth/password/change', 'PasswordController:getChangePassword')->setName('auth.password.change');

    $this->post('/auth/password/change', 'PasswordController:postChangePassword');

    // can add additional routes here if the user has to be signed in to access them

})->add(new AuthMiddleware($container));





