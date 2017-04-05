<?php

session_start();

require __DIR__ . '/../vendor/autoload.php';

$user = new \App\models\user;

var_dump($user);

die();

$app = new \Slim\App([

    'settings' => [

        'displayErrorDetails' => true,

    ]

]);

$container = $app->getContainer();

$container['view'] = function($container){

    $view = new \Slim\Views\Twig(__DIR__ . '/../resources/views', [

        'cache' =>false,

        ]);

    $view->addExtension(new \Slim\Views\TwigExtension(

        $container->router,

        $container->request->getUri()

    ));

    return $view;

};

require __DIR__ . '/../app/routes.php';
