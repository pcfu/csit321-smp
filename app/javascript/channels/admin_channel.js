import { createConsumer } from "@rails/actioncable";
import Alerts from 'common/alerts';


class AdminChannel {
  constructor() {
    this.consumer = null;
    this.onReceive = null;
  }

  subscribe() {
    const channel = this;

    this.consumer = createConsumer("/websocket/admin");
    this.consumer.subscriptions.create({ channel: 'AdminChannel' }, {
      connected() {
        console.log("connected to admin channel");
      },

      disconnected() {
        console.log("disconnected fron admin channel");
      },

      received(data) {
        if (channel.onReceive === null) return;
        channel.onReceive(data);
      }
    });

    return channel;
  }

  onReceiveCallback(fn) {
    this.onReceive = fn;
  }
}

export default AdminChannel;
