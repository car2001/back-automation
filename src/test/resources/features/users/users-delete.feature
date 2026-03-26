Feature: DELETE usuarios

  Background:
    * def random = java.util.UUID.randomUUID() + ''
    * def uniqueEmail = 'qa_delete_' + random + '@mail.com'

  Scenario: Eliminar un usuario existente
    Given url baseUrl
    And path 'usuarios'
    And request
    """
    {
      "nome": "Usuario Eliminable",
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
    When method delete
    Then status 200
    And match response.message == 'Registro excluído com sucesso'

    Given url baseUrl
    And path 'usuarios', userId
    When method get
    Then status 400
    And match response.message == 'Usuário não encontrado'

  Scenario: Eliminar usuario inexistente
    Given url baseUrl
    And path 'usuarios', '1234567890abcdef'
    When method delete
    Then status 200