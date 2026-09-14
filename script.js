(function () {
  "use strict";

  // Menu mobile
  var toggle = document.getElementById("navToggle");
  var nav = document.getElementById("menu-principal");

  if (toggle && nav) {
    toggle.addEventListener("click", function () {
      var isOpen = nav.classList.toggle("is-open");
      toggle.setAttribute("aria-expanded", isOpen ? "true" : "false");
    });

    nav.querySelectorAll("a").forEach(function (link) {
      link.addEventListener("click", function () {
        nav.classList.remove("is-open");
        toggle.setAttribute("aria-expanded", "false");
      });
    });
  }

  // Ano dinâmico no rodapé
  var anoEl = document.getElementById("anoAtual");
  if (anoEl) {
    anoEl.textContent = String(new Date().getFullYear());
  }

  // Marcação de clique nos CTAs de WhatsApp.
  // Se um pixel de conversão (Meta) for adicionado no <head>, este é o lugar
  // para disparar o evento de lead — ex.: fbq('track', 'Contact').
  document.querySelectorAll("[data-whatsapp-cta]").forEach(function (cta) {
    cta.addEventListener("click", function () {
      if (typeof window.fbq === "function") {
        window.fbq("track", "Contact");
      }
    });
  });
})();
