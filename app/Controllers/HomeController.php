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

        return $this->container->view->render($response, 'home.twig');

    }

}