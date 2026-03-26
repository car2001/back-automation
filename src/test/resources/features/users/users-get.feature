Feature: GET usuarios

Scenario: Obtener lista de usuarios
Given url baseUrl
And path 'usuarios'
When method get
Then status 200
And match response == read('classpath:schemas/user-list-schema.json')
And match each response.usuarios contains
"""
    {
      nome: '#string',
      email: '#string',
      password: '#string',
      administrador: '#string',
      _id: '#string'
    }
"""