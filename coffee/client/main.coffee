require ["findBirth", "graph", "typeAhead", "getPerson"], (findBirth, graph, typeAhead, getPerson) ->

  $(document).ready () ->
    typeAhead.attachWikiAutoComplete ".nameInput"

    $('.nameInput').on "keyup", (event) ->
      if event.keyCode == 13
        $('.findBirthDate').click()

    $('.findBirthDate').on "click", (event) ->
      searchName = $(".nameInput").val()
      getPerson.getPerson(searchName)