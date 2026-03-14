'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "b345cb64a1f4243496a72e95a2ecea3b",
"assets/AssetManifest.bin.json": "124993fe514edb2501f7ec5b459f8ae8",
"assets/AssetManifest.json": "0e0c4b534bd4aa0f9cb3e65042dab7de",
"assets/assets/images/baby.jpeg": "f700812db889104a87ce38e835781b0c",
"assets/assets/images/baby.jpg": "aaf6ca7d11a4b702a3bbdaccaf172308",
"assets/assets/images/birthday.jpg": "e62ff7e23ca8c942cab686ea432c99b5",
"assets/assets/images/birthday1.jpg": "0fd75b4ab7fd9af5246829e28e407be2",
"assets/assets/images/chennai.jpg": "b719728ef7d91d09f8c32482022f6b42",
"assets/assets/images/city1.jpg": "11345639df4b90dc724a17f2d09db817",
"assets/assets/images/corporate_event.jpeg": "2656b0f28022ce2552ff9b36f925c2a4",
"assets/assets/images/corporate_event.webp": "fa38eeccf3fbbc18c9858b60bb3cd754",
"assets/assets/images/drone1.jpg": "94156954e89928a9ad94939c261f4f95",
"assets/assets/images/hills.jpg": "af9ae91f343a8be67cbd4cf42ba5c4c6",
"assets/assets/images/img1.jpg": "1ab8c0e660248c7a005872a417da74cd",
"assets/assets/images/img2.jpg": "8896f274d637bbf975a407b174d3da08",
"assets/assets/images/img3.jpg": "086f3043525f3587866249c7b6590d7f",
"assets/assets/images/img4.jpg": "dd12ab47a288b3132882916f64514ac4",
"assets/assets/images/marriage1.jpg": "5ba0f1a98d799448882bc375dddd2fd4",
"assets/assets/images/marriage2.jpg": "8b7c20720cb23e8ea72c87e5a0968059",
"assets/assets/images/monkey.jpg": "89b5c616b66475ad3a28b709b97aebf7",
"assets/assets/images/nature.jpg": "1e75fed668810801a73569e5abffec9a",
"assets/assets/images/nature1.jpg": "c076055b0cae92d1561eb44b91f47c58",
"assets/assets/images/nature2.jpg": "71e4aba91a1854c3093b1590517d358b",
"assets/assets/images/nature3.jpg": "efb0e7194b40f551fecaa7f781f419ca",
"assets/assets/images/nature4.jpg": "cfd63e9ee78e73c2d4ca06ecd4fede7d",
"assets/assets/images/portrait.jpeg": "4142ba76cc7024f8226ed000b5445139",
"assets/assets/images/product.jpg": "73a6ab111a6db9d3181afa2988ef7328",
"assets/assets/images/product.webp": "2e65429bd3430b18cb3920f33b6a960e",
"assets/assets/images/temple.jpg": "60e6efdb649e1896d61816329f7303f8",
"assets/assets/images/travel.jpg": "ecf9efdc0ab09bd575102a7c7c1664a7",
"assets/assets/images/wedding.jpg": "c52edda8bdd4c66661f1e24ddd36c976",
"assets/FontManifest.json": "c75f7af11fb9919e042ad2ee704db319",
"assets/fonts/MaterialIcons-Regular.otf": "c7a3d021c74e80411271acb44f58f460",
"assets/NOTICES": "599326bd81d345b7b3ede1a71958d658",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Brands-Regular-400.otf": "2f60eda9a5962e304c90415a733ab1fc",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Free-Regular-400.otf": "b2703f18eee8303425a5342dba6958db",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Free-Solid-900.otf": "5b8d20acec3e57711717f61417c1be44",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"flutter_bootstrap.js": "77630cddf0ef5ca877642227e69d706f",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "66e3534254080cc9f65b928e26676b53",
"/": "66e3534254080cc9f65b928e26676b53",
"main.dart.js": "1e6412fcc0cf599d538ae64c06be6549",
"manifest.json": "a4f6fff8ec652ce455b73876d1c494dc",
"version.json": "70ee2b1221c2dbd4e8f484a91d04ba7e",
"_redirects": "6a02faf7ea2a9584134ffe15779a0e44"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
