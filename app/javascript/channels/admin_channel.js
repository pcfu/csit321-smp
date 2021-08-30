import consumer from "./consumer";

if (window.location.pathname.includes('admin')) {
  consumer.subscriptions.create({ channel: 'AdminChannel' }, {
    received(data) {
      console.log("received from websocket");
    }
  });
}
