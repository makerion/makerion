import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

let channel = socket.channel("printer_events", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

channel.on("printer_status", payload => {
  let printerStatus = document.getElementById('printer_status')
  printerStatus.innerText = payload.message
})

export default socket

socket.connect()
