const MANIFEST_URL = 'manifest.json';
const localHost = ['127.0.0.1', 'localhost']

async function main() {
  const isLocal = localHost.includes(window.location.hostname)
  //console.log('isLocal? ' + isLocal);

  const manifestJSON = await (await fetch(MANIFEST_URL)).json();
  const host = isLocal ? manifestJSON.localHost : manifestJSON.productionHost;
  //console.log('host?', host);

  const videoComponent = new VideoComponent();
  const network = new Network({ host })
  const videoPLayer = new VideoMediaPlayer({ manifestJSON, network });
  
  videoPLayer.initializeCodec()
  videoComponent.initializerPlayer();
}

window.onload = main