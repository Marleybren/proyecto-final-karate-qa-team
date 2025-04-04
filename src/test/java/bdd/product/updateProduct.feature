Feature: Casos de Prueba sobre Actualización de Productos

    Background:
        * def responseLogin = call read('classpath:bdd/auth/loginAuth.feature@login_OK')
        * print responseLogin
        * def tokenAuth = responseLogin.token_auth
        * print tokenAuth
        * url urlBase
        * header Accept = 'application/json'
        * header Authorization = 'Bearer ' + tokenAuth

    @ActProductos_OK
    Scenario: CP01 - Actualizar datos de un producto en especifico
       # * def nombreProd = "BGM Producto"
        * def id = 497
        * def body =
        """
        {
            "codigo": "BGM001",
            "nombre": "BGM Producto - Actualizado",
            "medida": "KG ",
            "marca": "HP",
            "categoria": "Repuestos",
            "precio": "500.00",
            "stock": "70",
            "estado": "1",
            "descripcion": "BGM Descripcion - Actualizado"
         }
        """
        And path "/api/v1/producto/" + id
        And request body
        When method put
        Then status 200
        * print response
        And match responseType == "json"
        And match $..id contains '#notnull'
        And match $..nombre contains body.nombre
        And match response.codigo == '#? _.length == 6'


    @ActProductos_OK_CodDist
        #Se obtiene error porque es un bug del API, los codigos deberian ser distintos
    Scenario: CP02 - Actualizar datos de un producto con código distinto
        * def id = 497
        * def body =
        """
        {
            "codigo": "TC0001",
            "nombre": "BGM Producto - Act",
            "medida": "KG ",
            "marca": "HP",
            "categoria": "Repuestos",
            "precio": "2000.00",
            "stock": "5",
            "estado": "1",
            "descripcion": "BGM Descripcion - Act"
         }
        """
        And path "/api/v1/producto/" + id
        And request body
        When method put
        Then status 200
        * print response
        And match responseType == "json"
        And match $.codigo == body.codigo
        And match $..nombre contains body.nombre

    @ActProductos_NOOK
    Scenario: CP03 - Actualizar datos de un producto no existente
        * def id = 000
        * def body =
        """
        {
            "codigo": "TC0001",
            "nombre": "BGM Producto - Act",
            "medida": "KG ",
            "marca": "HP",
            "categoria": "Repuestos",
            "precio": "2000.00",
            "stock": "5",
            "estado": "1",
            "descripcion": "BGM Descripcion - Act"
         }
        """
        And path "/api/v1/producto/" + id
        And request body
        When method put
        Then status 500
        * print response
        And match responseType == "json"
        And match $.error == "Call to a member function update() on null"
        And match $.error contains '#notnull'