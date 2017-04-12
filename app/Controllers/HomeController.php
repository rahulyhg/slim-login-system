<?php
/**
 * Created by PhpStorm.
 * User: matt
 * Date: 4/5/17
 * Time: 12:49 PM
 */

namespace App\Controllers;

use App\Models\User;
use Slim\Views\Twig as View;

class HomeController extends Controller
{

    public function index($request, $response)
    {

        // you can find all the methods in the laravel docs for eloquent
        // things such as where clauses, etc

        //$user = User::find(1);
        //$user = User::where('email', 'mattmegabit@gmail.com')->first();
        //var_dump($user->email);


        return $this->container->view->render($response, 'home.twig');

    }

}