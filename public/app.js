$(document).ready(function () {
  let deck = [];
  let commander = null;

  // Manejar el formulario de registro
  $("#register-form").on("submit", function (event) {
    event.preventDefault();
    const username = $("#username").val();
    const email = $("#email").val();
    const password = $("#password").val();

    console.log("Datos enviados para registro:", username, email, password);

    $.ajax({
      url: "/api/register",
      method: "POST",
      data: JSON.stringify({ username, email, password }),
      contentType: "application/json",
      success: function (data) {
        // Mostrar ventana emergente de registro exitoso
        $("#registerSuccessModal").modal("show");
        // Opcional: Redirigir después de un tiempo
        setTimeout(() => {
          window.location.href = "login.html";
        }, 2000);
      },
      error: function (err) {
        alert("Error en el registro");
        console.error("Error en el registro:", err);
      },
    });
  });

  // Verificar si hay una sesión activa y mostrar el nombre del usuario
  $.get("/api/auth", function (data) {
    if (data.authenticated) {
      $("#nav-user").html(`
              <li class="nav-item dropdown">
                  <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                      ${data.username}
                  </a>
                  <div class="dropdown-menu dropdown-menu-right" aria-labelledby="navbarDropdown">
                      <a class="dropdown-item" href="#">Mis Favoritos</a>
                      <a class="dropdown-item" href="mis_decks.html">Mis Decks</a>
                      <a class="dropdown-item" href="constr-deck.html">Crear Deck</a>
                      <div class="dropdown-divider"></div>
                      <a class="dropdown-item" href="#" id="logout">Logout</a>
                  </div>
              </li>
          `);
    } else {
      $("#nav-user").html(`
              <li class="nav-item">
                  <a class="btn btn-primary mr-2" href="login.html">Iniciar Sesión</a>
              </li>
              <li class="nav-item">
                  <a class="btn btn-secondary" href="register.html">Registrarse</a>
              </li>
          `);
    }
  }).fail(function () {
    $("#nav-user").html(`
          <li class="nav-item">
              <a class="btn btn-primary mr-2" href="login.html">Iniciar Sesión</a>
          </li>
          <li class="nav-item">
              <a class="btn btn-secondary" href="register.html">Registrarse</a>
          </li>
      `);
  });

  // Manejar el botón de logout
  $("#nav-user").on("click", "#logout", function (event) {
    event.preventDefault();
    $.post("/api/logout", function (data) {
      window.location.href = "index.html";
    });
  });

  // Manejar el formulario de inicio de sesión
  $("#login-form").on("submit", function (event) {
    event.preventDefault();
    const userOrEmail = $("#user-or-email").val();
    const password = $("#password").val();

    console.log("Datos enviados para inicio de sesión:", userOrEmail, password);

    $.ajax({
      url: "/api/login",
      method: "POST",
      data: JSON.stringify({ userOrEmail, password }),
      contentType: "application/json",
      success: function (data) {
        // Guardar la información del usuario en localStorage
        localStorage.setItem("currentUser", JSON.stringify(data.user));

        // Redirigir al usuario a la página de inicio
        window.location.href = "index.html";
      },
      error: function (err) {
        alert("Correo o contraseña incorrectos");
        console.error("Error en el inicio de sesión:", err);
      },
    });
  });

  // Mostrar el modal de búsqueda avanzada
  $("#button-advanced-search").on("click", function () {
    $("#advancedSearchModal").modal("show");
  });

  // Manejar el formulario de búsqueda avanzada
  $("#advanced-search-form").on("submit", function (event) {
    event.preventDefault();
    const deckName = $("#deck-name").val();
    const deckColors = $("#deck-colors").val();
    const cardName = $("#card-name").val();

    console.log(
      "Datos enviados para búsqueda avanzada:",
      deckName,
      deckColors,
      cardName
    );

    // Realiza aquí la solicitud al servidor para la búsqueda avanzada
    $.ajax({
      url: "/api/decks/search",
      method: "GET",
      data: { name: deckName, colors: deckColors, cardName },
      success: function (data) {
        // Manejar los resultados de la búsqueda avanzada aquí
        console.log("Resultados de la búsqueda avanzada:", data);
        // Aquí puedes actualizar la interfaz de usuario con los resultados
      },
      error: function (err) {
        console.error("Error en la búsqueda avanzada:", err);
      },
    });
  });

  // Manejar la búsqueda de cartas
  $("#search-cards").on("click", function () {
    const query = $("#card-search-input").val();
    const color = $("#card-color").val();
    const type = $("#card-type").val();
    let searchQuery = query;

    if (color) {
      searchQuery += ` color:${color}`;
    }
    if (type) {
      searchQuery += ` type:${type}`;
    }

    console.log("Buscando cartas con query:", searchQuery);

    $.ajax({
      url: `/api/cards/search?query=${encodeURIComponent(searchQuery)}`,
      method: "GET",
      success: function (data) {
        const cards = data.data;
        let resultsHtml = "<ul class='list-group'>";
        cards.forEach((card) => {
          resultsHtml += `<li class='list-group-item' data-card-id="${card.id}" data-card-name="${card.name}" data-card-image="${card.image_uris.normal}" data-card-text="${card.oracle_text}">
                            <img src="${card.image_uris.small}" alt="${card.name}" />
                            ${card.name}
                          </li>`;
        });
        resultsHtml += "</ul>";
        $("#card-results").html(resultsHtml);
      },
      error: function (err) {
        alert("Error al buscar cartas");
        console.error("Error al buscar cartas:", err);
      },
    });
  });

  // Manejar la selección de cartas
  $("#card-results").on("click", ".list-group-item", function () {
    const cardId = $(this).data("card-id");
    const cardName = $(this).data("card-name");
    const cardImage = $(this).data("card-image");

    if (!commander) {
      commander = { id: cardId, name: cardName, image: cardImage };
      $("#commander-slot").html(
        `<li class='list-group-item commander-card' data-card-id="${commander.id}" data-card-image="${commander.image}" data-card-text="${commander.oracle_text}">
            <img src="${commander.image}" alt="${commander.name}" style="width: 100px; height: auto;" />
        </li>`
      );
    } else {
      deck.push({ id: cardId, name: cardName, image: cardImage });
      updateDeck();
    }
  });

  // Mostrar la carta en grande al pasar el cursor
  $("#card-results").on("mouseover", ".list-group-item", function () {
    const cardImage = $(this).data("card-image");
    const cardText = $(this).data("card-text");
    $("#selected-card").html(
      `<img src="${cardImage}" alt="Carta seleccionada" class="img-fluid" /><p>${cardText}</p>`
    );
  });

  // Hacer que las cartas de los resultados de búsqueda sean "draggables"
  $("#card-results").on("dragstart", ".list-group-item", function (event) {
    const cardId = $(this).data("card-id");
    const cardName = $(this).data("card-name");
    const cardImage = $(this).data("card-image");
    // Guardar información de la carta en el evento
    event.originalEvent.dataTransfer.setData("card-id", cardId);
    event.originalEvent.dataTransfer.setData("card-name", cardName);
    event.originalEvent.dataTransfer.setData("card-image", cardImage);
  });

  // Hacer que las zonas acepten el arrastre (permitir el "drop")
  $(".drop-zone").on("dragover", function (event) {
    event.preventDefault(); // Necesario para permitir el drop
    $(this).addClass("hover"); // Establecer el estilo de la zona cuando se arrastra sobre ella
  });

  // Eliminar el estilo de hover cuando se sale de la zona
  $(".drop-zone").on("dragleave", function () {
    $(this).removeClass("hover");
  });

  // Manejar el evento "drop" cuando se suelta una carta en una zona
  $(".drop-zone").on("drop", function (event) {
    event.preventDefault();
    const zone = $(this).data("zone");

    // Recuperar los datos de la carta arrastrada
    const cardId = event.originalEvent.dataTransfer.getData("card-id");
    const cardName = event.originalEvent.dataTransfer.getData("card-name");
    const cardImage = event.originalEvent.dataTransfer.getData("card-image");

    // Lógica para agregar la carta a la zona correspondiente
    if (zone === "commander" && !commander) {
      // Si es la zona de comandante y no hay uno seleccionado
      commander = { id: cardId, name: cardName, image: cardImage };
      $("#commander-slot").html(
        `<li class='list-group-item commander-card' data-card-id="${commander.id}" data-card-image="${commander.image}" data-card-text="${commander.oracle_text}">
            <img src="${commander.image}" alt="${commander.name}" style="width: 100px; height: auto;" />
        </li>`
      );
    } else if (zone === "deck") {
      // Si es la zona del deck
      deck.push({ id: cardId, name: cardName, image: cardImage });
      updateDeck();
    }

    $(this).removeClass("hover");
  });

  // Manejar la eliminación de cartas del main deck
  $("#main-deck").on("click", ".deck-card", function () {
    const cardId = $(this).data("card-id");
    // Filtrar la carta para eliminarla del deck
    deck = deck.filter((card) => card.id !== cardId);
    updateDeck();
  });

  // Manejar la eliminación de la carta de comandante
  $("#commander-slot").on("click", ".commander-card", function () {
    // Eliminar el comandante seleccionado
    commander = null;
    $("#commander-slot").html("<h4>Comandante</h4>"); // Resetear la zona de comandante
  });

  // Función para actualizar el deck (por ejemplo, en el main deck)
  function updateDeck() {
    let deckHtml = '<div class="table-responsive"><table class="table">';
    for (let i = 0; i < deck.length; i++) {
      if (i % 6 === 0) {
        if (i !== 0) {
          deckHtml += "</tr>";
        }
        deckHtml += "<tr>";
      }
      deckHtml += `<td class='deck-card' data-card-id="${deck[i].id}" data-card-image="${deck[i].image}" data-card-text="${deck[i].oracle_text}">
                      <img src="${deck[i].image}" alt="${deck[i].name}" class="img-fluid" />
                      
                    </td>`;
    }
    deckHtml += "</tr></table></div>"; // Cierra la última fila y tabla
    $("#main-deck").html(deckHtml);
    $("#card-count").text(deck.length);
  }

  // Mostrar el modal para nombrar el deck al hacer clic en "Guardar Deck"
  $("#save-deck").on("click", function () {
    $("#nameDeckModal").modal("show");
  });

  // Manejar el clic en el botón de confirmación de guardado en el modal
  $("#save-deck-confirm").on("click", function () {
    const deckName = $("#deck-name-input").val();
    if (!deckName) {
      alert("Por favor, introduce un nombre para el deck");
      return;
    }

    // Enviar los datos del deck al servidor para guardarlos en la base de datos
    $.ajax({
      url: "/api/save-deck",
      method: "POST",
      data: JSON.stringify({
        deckName: deckName,
        mainDeck: deck,
        commander: commander,
      }),
      contentType: "application/json",
      success: function (data) {
        console.log("Deck guardado:", data);
        // Redirigir al usuario a la página de inicio
        window.location.href = "index.html";
      },
      error: function (err) {
        alert("Error al guardar el deck");
        console.error("Error al guardar el deck:", err);
      },
    });
  });
  // Recuperar el usuario autenticado del almacenamiento local
  const currentUser = JSON.parse(localStorage.getItem("currentUser"));

  // Función para cargar los decks del usuario
  function loadUserDecks() {
    $.ajax({
      url: `/api/users/${currentUser.id}/decks`,
      method: "GET",
      success: function (decks) {
        const decksContainer = $("#decks-container");
        decksContainer.empty();

        decks.forEach((deck) => {
          const deckElement = $(`
                         <div class="col-md-4 mb-4">
                            <div class="card">
                                 <div class="card-body">
                                  <h5 class="card-title">${deck.name}</h5>
                                
                                  <p class="card-text"><strong>Colors:</strong> ${
                                    deck.colors || "N/A"
                                  }</p>
                                  <p class="card-text"><strong>Likes:</strong> ${
                                    deck.likes
                                  }</p>
                                  <a href="deck_details.html?deckId=${
                                    deck.id
                                  }" class="btn btn-primary">Ver Deck</a>
                              </div>
                          </div>
                            </div>
                        </div>
                  `);
          decksContainer.append(deckElement);
        });
      },
      error: function (err) {
        console.error("Error al cargar los decks:", err);
      },
    });
  }
  // Cargar los decks al cargar la página
  loadUserDecks();

  // Función para cargar todos los decks
  function loadAllDecks() {
    $.ajax({
      url: `/api/decks`,
      method: "GET",
      success: function (decks) {
        const decksContainer = $("#decks-container");

        decksContainer.empty();

        decks.forEach((deck) => {
          const deckElement = $(`
                        <div class="col-md-4 mb-4">
                            <div class="card">
                                <div class="card-body">
                                    <h5 class="card-title">${deck.name}</h5>
                                   
                                    <p class="card-text"><strong>Usuario:</strong> ${
                                      deck.user || "N/A"
                                    }</p>
                                    <p class="card-text"><strong>Colors:</strong> ${
                                      deck.colors || "N/A"
                                    }</p>
                                    <p class="card-text"><strong>Likes:</strong> ${
                                      deck.likes
                                    }</p>
                                </div>
                            </div>
                        </div>
                    `);
          decksContainer.append(deckElement);
        });
      },
      error: function (err) {
        console.error("Error al cargar los decks:", err);
      },
    });
  }

  // Cargar todos los decks al cargar la página
  if (window.location.pathname === "/decks.html") {
    loadAllDecks();
  }

  // Obtener el ID del deck desde la URL
  const urlParams = new URLSearchParams(window.location.search);
  const deckId = urlParams.get("deckId");

  // Función para cargar las cartas del deck
  function loadDeck(deckId) {
    $.ajax({
      url: `/api/decks/${deckId}`,
      method: "GET",
      success: function (deck) {
        $("#main-deck").html(
          deck.mainDeck.map((card) => `<div>${card}</div>`).join("")
        );
        $("#commander-slot").html(`<div>${deck.commander}</div>`);
        $("#card-count").text(deck.mainDeck.length);
      },
      error: function (err) {
        console.error("Error al cargar el deck:", err);
      },
    });
  }

  // Función para cargar todos los decks
  function loadAllDecks() {
    $.ajax({
      url: `/api/decks`,
      method: "GET",
      success: function (decks) {
        const decksContainer = $("#decks-container");
        decksContainer.empty();

        decks.forEach((deck) => {
          const deckElement = $(`
                      <div class="col-md-4 mb-4">
                          <div class="card">
                              <div class="card-body">
                                  <h5 class="card-title">${deck.name}</h5>
                                  <p class="card-text"><strong>Usuario:</strong> ${
                                    deck.user || "N/A"
                                  }</p>
                                  <p class="card-text"><strong>Colors:</strong> ${
                                    deck.colors || "N/A"
                                  }</p>
                                  <p class="card-text"><strong>Likes:</strong> ${
                                    deck.likes
                                  }</p>
                                  <a href="deck_details.html?deckId=${
                                    deck.id
                                  }" class="btn btn-primary">Ver Deck</a>
                              </div>
                          </div>
                      </div>
                  `);
          decksContainer.append(deckElement);
        });
      },
      error: function (err) {
        console.error("Error al cargar los decks:", err);
      },
    });
  }

  // Función para cargar las cartas del deck
  function loadDeck(deckId) {
    $.ajax({
      url: `/api/decks/${deckId}`,
      method: "GET",
      success: function (deck) {
        const mainDeckContainer = $("#main-deck");
        const commanderSlot = $("#commander-slot");

        // Cargar las cartas del main deck
        mainDeckContainer.empty();
        deck.cards.forEach((card) => {
          mainDeckContainer.append(
            `<div><img src="${card.imageUrl}" alt="${card.name}" style="width: 100px; height: auto;"></div>`
          );
        });

        // Cargar la carta del comandante
        commanderSlot.empty();
        commanderSlot.append(
          `<div><img src="${deck.commander.imageUrl}" alt="${deck.commander.name}" style="width: 100px; height: auto;"></div>`
        );

        // Actualizar el conteo de cartas
        $("#card-count").text(deck.cards.length);
      },
      error: function (err) {
        console.error("Error al cargar el deck:", err);
      },
    });
  }

  // Cargar los datos iniciales
  loadDeck(deckId);
  loadComments(deckId);

  // Función para cargar los detalles del deck, incluyendo el número de "me gusta"
  function loadDeck(deckId) {
    $.ajax({
      url: `/api/decks/${deckId}`,
      method: "GET",
      success: function (deck) {
        const mainDeckContainer = $("#main-deck");
        const commanderSlot = $("#commander-slot");

        // Cargar las cartas del main deck
        mainDeckContainer.empty();
        deck.cards.forEach((card) => {
          mainDeckContainer.append(
            `<div><img src="${card.imageUrl}" alt="${card.name}" style="width: 100px; height: auto;"></div>`
          );
        });

        // Cargar la carta del comandante
        commanderSlot.empty();
        commanderSlot.append(
          `<div><img src="${deck.commander.imageUrl}" alt="${deck.commander.name}" style="width: 100px; height: auto;"></div>`
        );

        // Actualizar el conteo de cartas
        $("#card-count").text(deck.cards.length);

        // Actualizar el número total de "me gusta"
        $("#likes-count").text(deck.likes);
      },
      error: function (err) {
        console.error("Error al cargar el deck:", err);
      },
    });
  }

  // Función para cargar los comentarios
  function loadComments(deckId) {
    $.ajax({
      url: `/api/decks/${deckId}/comments`,
      method: "GET",
      success: function (comments) {
        const commentsList = $("#comments-list");
        commentsList.empty();
        comments.forEach((comment) => {
          commentsList.append(
            `<div><strong>${comment.username}:</strong> ${comment.comment}</div>`
          );
        });
      },
      error: function (err) {
        console.error("Error al cargar los comentarios:", err);
      },
    });
  }

  // Manejar el envío de comentarios
  $("#submit-comment").on("click", function () {
    const commentText = $("#new-comment").val();
    if (!commentText.trim()) {
      alert("El comentario no puede estar vacío");
      return;
    }

    $.ajax({
      url: `/api/decks/${deckId}/comments`,
      method: "POST",
      data: JSON.stringify({ text: commentText }),
      contentType: "application/json",
      success: function () {
        loadComments(deckId);
        $("#new-comment").val("");
      },
      error: function (err) {
        if (err.status === 401) {
          alert("Debe estar autenticado para dejar un comentario");
          window.location.href = "login.html"; // Redirigir a la página de inicio de sesión
        } else {
          console.error("Error al enviar el comentario:", err);
          alert("Error al enviar el comentario");
        }
      },
    });
  });

  // Manejar los "me gusta"
  $("#like-button").on("click", function () {
    $.ajax({
      url: `/api/decks/${deckId}/like`,
      method: "POST",
      success: function (likes) {
        $("#likes-count").text(likes);
      },
      error: function (err) {
        if (err.status === 401) {
          alert("Debe estar autenticado para dar 'me gusta'");
          window.location.href = "login.html"; // Redirigir a la página de inicio de sesión
        } else {
          console.error("Error al dar 'me gusta':", err);
          alert("Error al dar 'me gusta'");
        }
      },
    });
  });
});
