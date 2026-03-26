Feature: GET usuario por id

  Background:
    * def random = java.util.UUID.randomUUID() + ''
    * def uniqueEmail = 'qa_get_' + random + '@mail.com'
    * def uniqueName = 'Usuario GET ' + random

  Scenario: Buscar usuario existente por ID
    Given url baseUrl
    And path 'usuarios'
    And request
    """
    {
      "nome": "#(uniqueName)",
      "email": "#(uniqueEmail)",
      "password": "Test1234",
      "administrador": "true"
    }
    """
    When method post
    Then status 201
    And def userId = response._id

    Given url baseUrl
    And path 'usuarios', userId
    When method get
    Then status 200
    And match response == read('classpath:schemas/user-schema.json')
    And match response._id == userId
    And match response.email == uniqueEmail
    And match response.nome == uniqueName

  Scenario: Buscar usuario inexistente por ID
    Given url baseUrl
    And path 'usuarios', '1234567890abcdef'
    When method get
    Then status 400
    * print response
    And match response.message == 'Usuário não encontrado'

  Scenario: No permitir buscar usuario con ID inválido
    Given url baseUrl
    And path 'usuarios', 'id-invalido-123'
    When method get
    Then status 400
    * print response
    And match response.id contains '16 caracteres'


  Scenario: ID con menos de 16 caracteres
    Given url baseUrl
    And path 'usuarios', '12345'
    When method get
    Then status 400

  Scenario: ID con más de 16 caracteres
    Given url baseUrl
    And path 'usuarios', '12345678901234567'
    When method get
    Then status 400