<?php
/**
 * Created by PhpStorm.
 * User: matt
 * Date: 4/5/17
 * Time: 12:49 PM
 */

namespace App\Controllers;

use Slim\Views\Twig as View;

class HomeController extends Controller
{

    public function index($request, $response)
    {

        // you can find all the methods in the laravel docs for eloquent
        // things such as where clauses, etc

        $user = $this->db->table('users')->find(1);

        var_dump($user);

        die();

        return $this->container->view->render($response, 'home.twig');

    }

}