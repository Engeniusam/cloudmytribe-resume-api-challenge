const counter = document.querySelector(".counter-number");
async function updateCounter() {
  let response = await fetch(
    "https://rzwsd6u775ozx5ykoumgi5zdqa0cjwed.lambda-url.us-west-2.on.aws/"
  );
  let data = await response.json();
  counter.innerHTML = `Views: ${data.views}`;
}

updateCounter();
// function that makes the counter
