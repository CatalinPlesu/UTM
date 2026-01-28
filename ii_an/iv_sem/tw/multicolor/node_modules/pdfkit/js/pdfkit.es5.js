import zlib from 'zlib';
import CryptoJS from 'crypto-js';
import saslprep from 'saslprep';
import fs from 'fs';
import fontkit from 'fontkit';
import { EventEmitter } from 'events';
import LineBreaker from 'linebreak';
import PNG from 'png-js';
import stream from 'stream';

var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) {
  return typeof obj;
} : function (obj) {
  return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj;
};

var classCallCheck = function (instance, Constructor) {
  if (!(instance instanceof Constructor)) {
    throw new TypeError("Cannot call a class as a function");
  }
};

var createClass = function () {
  function defineProperties(target, props) {
    for (var i = 0; i < props.length; i++) {
      var descriptor = props[i];
      descriptor.enumerable = descriptor.enumerable || false;
      descriptor.configurable = true;
      if ("value" in descriptor) descriptor.writable = true;
      Object.defineProperty(target, descriptor.key, descriptor);
    }
  }

  return function (Constructor, protoProps, staticProps) {
    if (protoProps) defineProperties(Constructor.prototype, protoProps);
    if (staticProps) defineProperties(Constructor, staticProps);
    return Constructor;
  };
}();

var inherits = function (subClass, superClass) {
  if (typeof superClass !== "function" && superClass !== null) {
    throw new TypeError("Super expression must either be null or a function, not " + typeof superClass);
  }

  subClass.prototype = Object.create(superClass && superClass.prototype, {
    constructor: {
      value: subClass,
      enumerable: false,
      writable: true,
      configurable: true
    }
  });
  if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass;
};

var possibleConstructorReturn = function (self, call) {
  if (!self) {
    throw new ReferenceError("this hasn't been initialised - super() hasn't been called");
  }

  return call && (typeof call === "object" || typeof call === "function") ? call : self;
};

var slicedToArray = function () {
  function sliceIterator(arr, i) {
    var _arr = [];
    var _n = true;
    var _d = false;
    var _e = undefined;

    try {
      for (var _i = arr[Symbol.iterator](), _s; !(_n = (_s = _i.next()).done); _n = true) {
        _arr.push(_s.value);

        if (i && _arr.length === i) break;
      }
    } catch (err) {
      _d = true;
      _e = err;
    } finally {
      try {
        if (!_n && _i["return"]) _i["return"]();
      } finally {
        if (_d) throw _e;
      }
    }

    return _arr;
  }

  return function (arr, i) {
    if (Array.isArray(arr)) {
      return arr;
    } else if (Symbol.iterator in Object(arr)) {
      return sliceIterator(arr, i);
    } else {
      throw new TypeError("Invalid attempt to destructure non-iterable instance");
    }
  };
}();

var toConsumableArray = function (arr) {
  if (Array.isArray(arr)) {
    for (var i = 0, arr2 = Array(arr.length); i < arr.length; i++) arr2[i] = arr[i];

    return arr2;
  } else {
    return Array.from(arr);
  }
};

/*
PDFAbstractReference - abstract class for PDF reference
*/

var PDFAbstractReference = function () {
  function PDFAbstractReference() {
    classCallCheck(this, PDFAbstractReference);
  }

  createClass(PDFAbstractReference, [{
    key: 'toString',
    value: function toString() {
      throw new Error('Must be implemented by subclasses');
    }
  }]);
  return PDFAbstractReference;
}();

/*
PDFObject - converts JavaScript types into their corresponding PDF types.
By Devon Govett
*/

var pad = function pad(str, length) {
  return (Array(length + 1).join('0') + str).slice(-length);
};

var escapableRe = /[\n\r\t\b\f\(\)\\]/g;
var escapable = {
  '\n': '\\n',
  '\r': '\\r',
  '\t': '\\t',
  '\b': '\\b',
  '\f': '\\f',
  '\\': '\\\\',
  '(': '\\(',
  ')': '\\)'
};

// Convert little endian UTF-16 to big endian
var swapBytes = function swapBytes(buff) {
  var l = buff.length;
  if (l & 0x01) {
    throw new Error('Buffer length must be even');
  } else {
    for (var i = 0, end = l - 1; i < end; i += 2) {
      var a = buff[i];
      buff[i] = buff[i + 1];
      buff[i + 1] = a;
    }
  }

  return buff;
};

var PDFObject = function () {
  function PDFObject() {
    classCallCheck(this, PDFObject);
  }

  createClass(PDFObject, null, [{
    key: 'convert',
    value: function convert(object) {
      var encryptFn = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : null;

      // String literals are converted to the PDF name type
      if (typeof object === 'string') {
        return '/' + object;

        // String objects are converted to PDF strings (UTF-16)
      } else if (object instanceof String) {
        var string = object;
        // Detect if this is a unicode string
        var isUnicode = false;
        for (var i = 0, end = string.length; i < end; i++) {
          if (string.charCodeAt(i) > 0x7f) {
            isUnicode = true;
            break;
          }
        }

        // If so, encode it as big endian UTF-16
        var stringBuffer = void 0;
        if (isUnicode) {
          stringBuffer = swapBytes(new Buffer('\uFEFF' + string, 'utf16le'));
        } else {
          stringBuffer = new Buffer(string, 'ascii');
        }

        // Encrypt the string when necessary
        if (encryptFn) {
          string = encryptFn(stringBuffer).toString('binary');
        } else {
          string = stringBuffer.toString('binary');
        }

        // Escape characters as required by the spec
        string = string.replace(escapableRe, function (c) {
          return escapable[c];
        });

        return '(' + string + ')';

        // Buffers are converted to PDF hex strings
      } else if (Buffer.isBuffer(object)) {
        return '<' + object.toString('hex') + '>';
      } else if (object instanceof PDFAbstractReference) {
        return object.toString();
      } else if (object instanceof Date) {
        var _string = 'D:' + pad(object.getUTCFullYear(), 4) + pad(object.getUTCMonth() + 1, 2) + pad(object.getUTCDate(), 2) + pad(object.getUTCHours(), 2) + pad(object.getUTCMinutes(), 2) + pad(object.getUTCSeconds(), 2) + 'Z';

        // Encrypt the string when necessary
        if (encryptFn) {
          _string = encryptFn(new Buffer(_string, 'ascii')).toString('binary');

          // Escape characters as required by the spec
          _string = _string.replace(escapableRe, function (c) {
            return escapable[c];
          });
        }

        return '(' + _string + ')';
      } else if (Array.isArray(object)) {
        var items = object.map(function (e) {
          return PDFObject.convert(e, encryptFn);
        }).join(' ');
        return '[' + items + ']';
      } else if ({}.toString.call(object) === '[object Object]') {
        var out = ['<<'];
        for (var key in object) {
          var val = object[key];
          out.push('/' + key + ' ' + PDFObject.convert(val, encryptFn));
        }

        out.push('>>');
        return out.join('\n');
      } else if (typeof object === 'number') {
        return PDFObject.number(object);
      } else {
        return '' + object;
      }
    }
  }, {
    key: 'number',
    value: function number(n) {
      if (n > -1e21 && n < 1e21) {
        return Math.round(n * 1e6) / 1e6;
      }

      throw new Error('unsupported number: ' + n);
    }
  }]);
  return PDFObject;
}();

/*
PDFReference - represents a reference to another object in the PDF object heirarchy
By Devon Govett
*/

var PDFReference = function (_PDFAbstractReference) {
  inherits(PDFReference, _PDFAbstractReference);

  function PDFReference(document, id, data) {
    classCallCheck(this, PDFReference);

    var _this = possibleConstructorReturn(this, (PDFReference.__proto__ || Object.getPrototypeOf(PDFReference)).call(this));

    _this.document = document;
    _this.id = id;
    if (data == null) {
      data = {};
    }
    _this.data = data;
    _this.gen = 0;
    _this.compress = _this.document.compress && !_this.data.Filter;
    _this.uncompressedLength = 0;
    _this.buffer = [];
    return _this;
  }

  createClass(PDFReference, [{
    key: 'write',
    value: function write(chunk) {
      if (!Buffer.isBuffer(chunk)) {
        chunk = new Buffer(chunk + '\n', 'binary');
      }

      this.uncompressedLength += chunk.length;
      if (this.data.Length == null) {
        this.data.Length = 0;
      }
      this.buffer.push(chunk);
      this.data.Length += chunk.length;
      if (this.compress) {
        return this.data.Filter = 'FlateDecode';
      }
    }
  }, {
    key: 'end',
    value: function end(chunk) {
      if (chunk) {
        this.write(chunk);
      }
      return this.finalize();
    }
  }, {
    key: 'finalize',
    value: function finalize() {
      this.offset = this.document._offset;

      var encryptFn = this.document._security ? this.document._security.getEncryptFn(this.id, this.gen) : null;

      if (this.buffer.length) {
        this.buffer = Buffer.concat(this.buffer);
        if (this.compress) {
          this.buffer = zlib.deflateSync(this.buffer);
        }

        if (encryptFn) {
          this.buffer = encryptFn(this.buffer);
        }

        this.data.Length = this.buffer.length;
      }

      this.document._write(this.id + ' ' + this.gen + ' obj');
      this.document._write(PDFObject.convert(this.data, encryptFn));

      if (this.buffer.length) {
        this.document._write('stream');
        this.document._write(this.buffer);

        this.buffer = []; // free up memory
        this.document._write('\nendstream');
      }

      this.document._write('endobj');
      this.document._refEnd(this);
    }
  }, {
    key: 'toString',
    value: function toString() {
      return this.id + ' ' + this.gen + ' R';
    }
  }]);
  return PDFReference;
}(PDFAbstractReference);

/*
PDFPage - represents a single page in the PDF document
By Devon Govett
*/

var DEFAULT_MARGINS = {
  top: 72,
  left: 72,
  bottom: 72,
  right: 72
};

var SIZES = {
  '4A0': [4767.87, 6740.79],
  '2A0': [3370.39, 4767.87],
  A0: [2383.94, 3370.39],
  A1: [1683.78, 2383.94],
  A2: [1190.55, 1683.78],
  A3: [841.89, 1190.55],
  A4: [595.28, 841.89],
  A5: [419.53, 595.28],
  A6: [297.64, 419.53],
  A7: [209.76, 297.64],
  A8: [147.4, 209.76],
  A9: [104.88, 147.4],
  A10: [73.7, 104.88],
  B0: [2834.65, 4008.19],
  B1: [2004.09, 2834.65],
  B2: [1417.32, 2004.09],
  B3: [1000.63, 1417.32],
  B4: [708.66, 1000.63],
  B5: [498.9, 708.66],
  B6: [354.33, 498.9],
  B7: [249.45, 354.33],
  B8: [175.75, 249.45],
  B9: [124.72, 175.75],
  B10: [87.87, 124.72],
  C0: [2599.37, 3676.54],
  C1: [1836.85, 2599.37],
  C2: [1298.27, 1836.85],
  C3: [918.43, 1298.27],
  C4: [649.13, 918.43],
  C5: [459.21, 649.13],
  C6: [323.15, 459.21],
  C7: [229.61, 323.15],
  C8: [161.57, 229.61],
  C9: [113.39, 161.57],
  C10: [79.37, 113.39],
  RA0: [2437.8, 3458.27],
  RA1: [1729.13, 2437.8],
  RA2: [1218.9, 1729.13],
  RA3: [864.57, 1218.9],
  RA4: [609.45, 864.57],
  SRA0: [2551.18, 3628.35],
  SRA1: [1814.17, 2551.18],
  SRA2: [1275.59, 1814.17],
  SRA3: [907.09, 1275.59],
  SRA4: [637.8, 907.09],
  EXECUTIVE: [521.86, 756.0],
  FOLIO: [612.0, 936.0],
  LEGAL: [612.0, 1008.0],
  LETTER: [612.0, 792.0],
  TABLOID: [792.0, 1224.0]
};

var PDFPage = function () {
  function PDFPage(document, options) {
    classCallCheck(this, PDFPage);

    this.document = document;
    if (options == null) {
      options = {};
    }
    this.size = options.size || 'letter';
    this.layout = options.layout || 'portrait';

    // process margins
    if (typeof options.margin === 'number') {
      this.margins = {
        top: options.margin,
        left: options.margin,
        bottom: options.margin,
        right: options.margin
      };

      // default to 1 inch margins
    } else {
      this.margins = options.margins || DEFAULT_MARGINS;
    }

    // calculate page dimensions
    var dimensions = Array.isArray(this.size) ? this.size : SIZES[this.size.toUpperCase()];
    this.width = dimensions[this.layout === 'portrait' ? 0 : 1];
    this.height = dimensions[this.layout === 'portrait' ? 1 : 0];

    this.content = this.document.ref();

    // Initialize the Font, XObject, and ExtGState dictionaries
    this.resources = this.document.ref({
      ProcSet: ['PDF', 'Text', 'ImageB', 'ImageC', 'ImageI']
    });

    // The page dictionary
    this.dictionary = this.document.ref({
      Type: 'Page',
      Parent: this.document._root.data.Pages,
      MediaBox: [0, 0, this.width, this.height],
      Contents: this.content,
      Resources: this.resources
    });
  }

  // Lazily create these dictionaries


  createClass(PDFPage, [{
    key: 'maxY',
    value: function maxY() {
      return this.height - this.margins.bottom;
    }
  }, {
    key: 'write',
    value: function write(chunk) {
      return this.content.write(chunk);
    }
  }, {
    key: 'end',
    value: function end() {
      this.dictionary.end();
      this.resources.end();
      return this.content.end();
    }
  }, {
    key: 'fonts',
    get: function get$$1() {
      var data = this.resources.data;
      return data.Font != null ? data.Font : data.Font = {};
    }
  }, {
    key: 'xobjects',
    get: function get$$1() {
      var data = this.resources.data;
      return data.XObject != null ? data.XObject : data.XObject = {};
    }
  }, {
    key: 'ext_gstates',
    get: function get$$1() {
      var data = this.resources.data;
      return data.ExtGState != null ? data.ExtGState : data.ExtGState = {};
    }
  }, {
    key: 'patterns',
    get: function get$$1() {
      var data = this.resources.data;
      return data.Pattern != null ? data.Pattern : data.Pattern = {};
    }
  }, {
    key: 'annotations',
    get: function get$$1() {
      var data = this.dictionary.data;
      return data.Annots != null ? data.Annots : data.Annots = [];
    }
  }]);
  return PDFPage;
}();

/*
   PDFSecurity - represents PDF security settings
   By Yang Liu <hi@zesik.com>
 */

var PDFSecurity = function () {
  createClass(PDFSecurity, null, [{
    key: 'generateFileID',
    value: function generateFileID() {
      var info = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};

      var infoStr = info.CreationDate.getTime() + '\n';

      for (var key in info) {
        if (!info.hasOwnProperty(key)) {
          continue;
        }
        infoStr += key + ': ' + info[key].toString() + '\n';
      }

      return wordArrayToBuffer(CryptoJS.MD5(infoStr));
    }
  }, {
    key: 'generateRandomWordArray',
    value: function generateRandomWordArray(bytes) {
      return CryptoJS.lib.WordArray.random(bytes);
    }
  }, {
    key: 'create',
    value: function create(document) {
      var options = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : {};

      if (!options.ownerPassword && !options.userPassword) {
        return null;
      }
      return new PDFSecurity(document, options);
    }
  }]);

  function PDFSecurity(document) {
    var options = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : {};
    classCallCheck(this, PDFSecurity);

    if (!options.ownerPassword && !options.userPassword) {
      throw new Error('None of owner password and user password is defined.');
    }

    this.document = document;
    this._setupEncryption(options);
  }

  createClass(PDFSecurity, [{
    key: '_setupEncryption',
    value: function _setupEncryption(options) {
      switch (options.pdfVersion) {
        case '1.4':
        case '1.5':
          this.version = 2;
          break;
        case '1.6':
        case '1.7':
          this.version = 4;
          break;
        case '1.7ext3':
          this.version = 5;
          break;
        default:
          this.version = 1;
          break;
      }

      var encDict = {
        Filter: 'Standard'
      };

      switch (this.version) {
        case 1:
        case 2:
        case 4:
          this._setupEncryptionV1V2V4(this.version, encDict, options);
          break;
        case 5:
          this._setupEncryptionV5(encDict, options);
          break;
      }

      this.dictionary = this.document.ref(encDict);
    }
  }, {
    key: '_setupEncryptionV1V2V4',
    value: function _setupEncryptionV1V2V4(v, encDict, options) {
      var r = void 0,
          permissions = void 0;
      switch (v) {
        case 1:
          r = 2;
          this.keyBits = 40;
          permissions = getPermissionsR2(options.permissions);
          break;
        case 2:
          r = 3;
          this.keyBits = 128;
          permissions = getPermissionsR3(options.permissions);
          break;
        case 4:
          r = 4;
          this.keyBits = 128;
          permissions = getPermissionsR3(options.permissions);
          break;
      }

      var paddedUserPassword = processPasswordR2R3R4(options.userPassword);
      var paddedOwnerPassword = options.ownerPassword ? processPasswordR2R3R4(options.ownerPassword) : paddedUserPassword;

      var ownerPasswordEntry = getOwnerPasswordR2R3R4(r, this.keyBits, paddedUserPassword, paddedOwnerPassword);
      this.encryptionKey = getEncryptionKeyR2R3R4(r, this.keyBits, this.document._id, paddedUserPassword, ownerPasswordEntry, permissions);
      var userPasswordEntry = void 0;
      if (r === 2) {
        userPasswordEntry = getUserPasswordR2(this.encryptionKey);
      } else {
        userPasswordEntry = getUserPasswordR3R4(this.document._id, this.encryptionKey);
      }

      encDict.V = v;
      if (v >= 2) {
        encDict.Length = this.keyBits;
      }
      if (v === 4) {
        encDict.CF = {
          StdCF: {
            AuthEvent: 'DocOpen',
            CFM: 'AESV2',
            Length: this.keyBits / 8
          }
        };
        encDict.StmF = 'StdCF';
        encDict.StrF = 'StdCF';
      }
      encDict.R = r;
      encDict.O = wordArrayToBuffer(ownerPasswordEntry);
      encDict.U = wordArrayToBuffer(userPasswordEntry);
      encDict.P = permissions;
    }
  }, {
    key: '_setupEncryptionV5',
    value: function _setupEncryptionV5(encDict, options) {
      this.keyBits = 256;
      var permissions = getPermissionsR3(options);

      var processedUserPassword = processPasswordR5(options.userPassword);
      var processedOwnerPassword = options.ownerPassword ? processPasswordR5(options.ownerPassword) : processedUserPassword;

      this.encryptionKey = getEncryptionKeyR5(PDFSecurity.generateRandomWordArray);
      var userPasswordEntry = getUserPasswordR5(processedUserPassword, PDFSecurity.generateRandomWordArray);
      var userKeySalt = CryptoJS.lib.WordArray.create(userPasswordEntry.words.slice(10, 12), 8);
      var userEncryptionKeyEntry = getUserEncryptionKeyR5(processedUserPassword, userKeySalt, this.encryptionKey);
      var ownerPasswordEntry = getOwnerPasswordR5(processedOwnerPassword, userPasswordEntry, PDFSecurity.generateRandomWordArray);
      var ownerKeySalt = CryptoJS.lib.WordArray.create(ownerPasswordEntry.words.slice(10, 12), 8);
      var ownerEncryptionKeyEntry = getOwnerEncryptionKeyR5(processedOwnerPassword, ownerKeySalt, userPasswordEntry, this.encryptionKey);
      var permsEntry = getEncryptedPermissionsR5(permissions, this.encryptionKey, PDFSecurity.generateRandomWordArray);

      encDict.V = 5;
      encDict.Length = this.keyBits;
      encDict.CF = {
        StdCF: {
          AuthEvent: 'DocOpen',
          CFM: 'AESV3',
          Length: this.keyBits / 8
        }
      };
      encDict.StmF = 'StdCF';
      encDict.StrF = 'StdCF';
      encDict.R = 5;
      encDict.O = wordArrayToBuffer(ownerPasswordEntry);
      encDict.OE = wordArrayToBuffer(ownerEncryptionKeyEntry);
      encDict.U = wordArrayToBuffer(userPasswordEntry);
      encDict.UE = wordArrayToBuffer(userEncryptionKeyEntry);
      encDict.P = permissions;
      encDict.Perms = wordArrayToBuffer(permsEntry);
    }
  }, {
    key: 'getEncryptFn',
    value: function getEncryptFn(obj, gen) {
      var digest = void 0;
      if (this.version < 5) {
        digest = this.encryptionKey.clone().concat(CryptoJS.lib.WordArray.create([(obj & 0xff) << 24 | (obj & 0xff00) << 8 | obj >> 8 & 0xff00 | gen & 0xff, (gen & 0xff00) << 16], 5));
      }

      if (this.version === 1 || this.version === 2) {
        var _key = CryptoJS.MD5(digest);
        _key.sigBytes = Math.min(16, this.keyBits / 8 + 5);
        return function (buffer) {
          return wordArrayToBuffer(CryptoJS.RC4.encrypt(CryptoJS.lib.WordArray.create(buffer), _key).ciphertext);
        };
      }

      var key = void 0;
      if (this.version === 4) {
        key = CryptoJS.MD5(digest.concat(CryptoJS.lib.WordArray.create([0x73416c54], 4)));
      } else {
        key = this.encryptionKey;
      }

      var iv = PDFSecurity.generateRandomWordArray(16);
      var options = {
        mode: CryptoJS.mode.CBC,
        padding: CryptoJS.pad.Pkcs7,
        iv: iv
      };

      return function (buffer) {
        return wordArrayToBuffer(iv.clone().concat(CryptoJS.AES.encrypt(CryptoJS.lib.WordArray.create(buffer), key, options).ciphertext));
      };
    }
  }, {
    key: 'end',
    value: function end() {
      this.dictionary.end();
    }
  }]);
  return PDFSecurity;
}();

function getPermissionsR2() {
  var permissionObject = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};

  var permissions = 0xffffffc0 >> 0;
  if (permissionObject.printing) {
    permissions |= 2;
  }
  if (permissionObject.modifying) {
    permissions |= 8;
  }
  if (permissionObject.copying) {
    permissions |= 16;
  }
  if (permissionObject.annotating) {
    permissions |= 32;
  }
  return permissions;
}

function getPermissionsR3() {
  var permissionObject = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};

  var permissions = 0xfffff0c0 >> 0;
  if (permissionObject.printing === 'lowResolution') {
    permissions |= 4;
  }
  if (permissionObject.printing === 'highResolution') {
    permissions |= 2052;
  }
  if (permissionObject.modifying) {
    permissions |= 8;
  }
  if (permissionObject.copying) {
    permissions |= 16;
  }
  if (permissionObject.annotating) {
    permissions |= 32;
  }
  if (permissionObject.fillingForms) {
    permissions |= 256;
  }
  if (permissionObject.contentAccessibility) {
    permissions |= 512;
  }
  if (permissionObject.documentAssembly) {
    permissions |= 1024;
  }
  return permissions;
}

function getUserPasswordR2(encryptionKey) {
  return CryptoJS.RC4.encrypt(processPasswordR2R3R4(), encryptionKey).ciphertext;
}

function getUserPasswordR3R4(documentId, encryptionKey) {
  var key = encryptionKey.clone();
  var cipher = CryptoJS.MD5(processPasswordR2R3R4().concat(CryptoJS.lib.WordArray.create(documentId)));
  for (var i = 0; i < 20; i++) {
    var xorRound = Math.ceil(key.sigBytes / 4);
    for (var j = 0; j < xorRound; j++) {
      key.words[j] = encryptionKey.words[j] ^ (i | i << 8 | i << 16 | i << 24);
    }
    cipher = CryptoJS.RC4.encrypt(cipher, key).ciphertext;
  }
  return cipher.concat(CryptoJS.lib.WordArray.create(null, 16));
}

function getOwnerPasswordR2R3R4(r, keyBits, paddedUserPassword, paddedOwnerPassword) {
  var digest = paddedOwnerPassword;
  var round = r >= 3 ? 51 : 1;
  for (var i = 0; i < round; i++) {
    digest = CryptoJS.MD5(digest);
  }

  var key = digest.clone();
  key.sigBytes = keyBits / 8;
  var cipher = paddedUserPassword;
  round = r >= 3 ? 20 : 1;
  for (var _i = 0; _i < round; _i++) {
    var xorRound = Math.ceil(key.sigBytes / 4);
    for (var j = 0; j < xorRound; j++) {
      key.words[j] = digest.words[j] ^ (_i | _i << 8 | _i << 16 | _i << 24);
    }
    cipher = CryptoJS.RC4.encrypt(cipher, key).ciphertext;
  }
  return cipher;
}

function getEncryptionKeyR2R3R4(r, keyBits, documentId, paddedUserPassword, ownerPasswordEntry, permissions) {
  var key = paddedUserPassword.clone().concat(ownerPasswordEntry).concat(CryptoJS.lib.WordArray.create([lsbFirstWord(permissions)], 4)).concat(CryptoJS.lib.WordArray.create(documentId));
  var round = r >= 3 ? 51 : 1;
  for (var i = 0; i < round; i++) {
    key = CryptoJS.MD5(key);
    key.sigBytes = keyBits / 8;
  }
  return key;
}

function getUserPasswordR5(processedUserPassword, generateRandomWordArray) {
  var validationSalt = generateRandomWordArray(8);
  var keySalt = generateRandomWordArray(8);
  return CryptoJS.SHA256(processedUserPassword.clone().concat(validationSalt)).concat(validationSalt).concat(keySalt);
}

function getUserEncryptionKeyR5(processedUserPassword, userKeySalt, encryptionKey) {
  var key = CryptoJS.SHA256(processedUserPassword.clone().concat(userKeySalt));
  var options = {
    mode: CryptoJS.mode.CBC,
    padding: CryptoJS.pad.NoPadding,
    iv: CryptoJS.lib.WordArray.create(null, 16)
  };
  return CryptoJS.AES.encrypt(encryptionKey, key, options).ciphertext;
}

function getOwnerPasswordR5(processedOwnerPassword, userPasswordEntry, generateRandomWordArray) {
  var validationSalt = generateRandomWordArray(8);
  var keySalt = generateRandomWordArray(8);
  return CryptoJS.SHA256(processedOwnerPassword.clone().concat(validationSalt).concat(userPasswordEntry)).concat(validationSalt).concat(keySalt);
}

function getOwnerEncryptionKeyR5(processedOwnerPassword, ownerKeySalt, userPasswordEntry, encryptionKey) {
  var key = CryptoJS.SHA256(processedOwnerPassword.clone().concat(ownerKeySalt).concat(userPasswordEntry));
  var options = {
    mode: CryptoJS.mode.CBC,
    padding: CryptoJS.pad.NoPadding,
    iv: CryptoJS.lib.WordArray.create(null, 16)
  };
  return CryptoJS.AES.encrypt(encryptionKey, key, options).ciphertext;
}

function getEncryptionKeyR5(generateRandomWordArray) {
  return generateRandomWordArray(32);
}

function getEncryptedPermissionsR5(permissions, encryptionKey, generateRandomWordArray) {
  var cipher = CryptoJS.lib.WordArray.create([lsbFirstWord(permissions), 0xffffffff, 0x54616462], 12).concat(generateRandomWordArray(4));
  var options = {
    mode: CryptoJS.mode.ECB,
    padding: CryptoJS.pad.NoPadding
  };
  return CryptoJS.AES.encrypt(cipher, encryptionKey, options).ciphertext;
}

function processPasswordR2R3R4() {
  var password = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : '';

  var out = new Buffer(32);
  var length = password.length;
  var index = 0;
  while (index < length && index < 32) {
    var code = password.charCodeAt(index);
    if (code > 0xff) {
      throw new Error('Password contains one or more invalid characters.');
    }
    out[index] = code;
    index++;
  }
  while (index < 32) {
    out[index] = PASSWORD_PADDING[index - length];
    index++;
  }
  return CryptoJS.lib.WordArray.create(out);
}

function processPasswordR5() {
  var password = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : '';

  password = unescape(encodeURIComponent(saslprep(password)));
  var length = Math.min(127, password.length);
  var out = new Buffer(length);

  for (var i = 0; i < length; i++) {
    out[i] = password.charCodeAt(i);
  }

  return CryptoJS.lib.WordArray.create(out);
}

function lsbFirstWord(data) {
  return (data & 0xff) << 24 | (data & 0xff00) << 8 | data >> 8 & 0xff00 | data >> 24 & 0xff;
}

function wordArrayToBuffer(wordArray) {
  var byteArray = [];
  for (var i = 0; i < wordArray.sigBytes; i++) {
    byteArray.push(wordArray.words[Math.floor(i / 4)] >> 8 * (3 - i % 4) & 0xff);
  }
  return Buffer.from(byteArray);
}

var PASSWORD_PADDING = [0x28, 0xbf, 0x4e, 0x5e, 0x4e, 0x75, 0x8a, 0x41, 0x64, 0x00, 0x4e, 0x56, 0xff, 0xfa, 0x01, 0x08, 0x2e, 0x2e, 0x00, 0xb6, 0xd0, 0x68, 0x3e, 0x80, 0x2f, 0x0c, 0xa9, 0xfe, 0x64, 0x53, 0x69, 0x7a];

var number = PDFObject.number;

var PDFGradient = function () {
  function PDFGradient(doc) {
    classCallCheck(this, PDFGradient);

    this.doc = doc;
    this.stops = [];
    this.embedded = false;
    this.transform = [1, 0, 0, 1, 0, 0];
  }

  createClass(PDFGradient, [{
    key: 'stop',
    value: function stop(pos, color, opacity) {
      if (opacity == null) {
        opacity = 1;
      }
      color = this.doc._normalizeColor(color);

      if (this.stops.length === 0) {
        if (color.length === 3) {
          this._colorSpace = 'DeviceRGB';
        } else if (color.length === 4) {
          this._colorSpace = 'DeviceCMYK';
        } else if (color.length === 1) {
          this._colorSpace = 'DeviceGray';
        } else {
          throw new Error('Unknown color space');
        }
      } else if (this._colorSpace === 'DeviceRGB' && color.length !== 3 || this._colorSpace === 'DeviceCMYK' && color.length !== 4 || this._colorSpace === 'DeviceGray' && color.length !== 1) {
        throw new Error('All gradient stops must use the same color space');
      }

      opacity = Math.max(0, Math.min(1, opacity));
      this.stops.push([pos, color, opacity]);
      return this;
    }
  }, {
    key: 'setTransform',
    value: function setTransform(m11, m12, m21, m22, dx, dy) {
      this.transform = [m11, m12, m21, m22, dx, dy];
      return this;
    }
  }, {
    key: 'embed',
    value: function embed(m) {
      var asc = void 0,
          i = void 0;
      var end = void 0,
          fn = void 0;
      if (this.stops.length === 0) {
        return;
      }
      this.embedded = true;
      this.matrix = m;

      // if the last stop comes before 100%, add a copy at 100%
      var last = this.stops[this.stops.length - 1];
      if (last[0] < 1) {
        this.stops.push([1, last[1], last[2]]);
      }

      var bounds = [];
      var encode = [];
      var stops = [];

      for (i = 0, end = this.stops.length - 1, asc = 0 <= end; asc ? i < end : i > end; asc ? i++ : i--) {
        encode.push(0, 1);
        if (i + 2 !== this.stops.length) {
          bounds.push(this.stops[i + 1][0]);
        }

        fn = this.doc.ref({
          FunctionType: 2,
          Domain: [0, 1],
          C0: this.stops[i + 0][1],
          C1: this.stops[i + 1][1],
          N: 1
        });

        stops.push(fn);
        fn.end();
      }

      // if there are only two stops, we don't need a stitching function
      if (stops.length === 1) {
        fn = stops[0];
      } else {
        fn = this.doc.ref({
          FunctionType: 3, // stitching function
          Domain: [0, 1],
          Functions: stops,
          Bounds: bounds,
          Encode: encode
        });

        fn.end();
      }

      this.id = 'Sh' + ++this.doc._gradCount;

      var shader = this.shader(fn);
      shader.end();

      var pattern = this.doc.ref({
        Type: 'Pattern',
        PatternType: 2,
        Shading: shader,
        Matrix: this.matrix.map(function (v) {
          return number(v);
        })
      });

      pattern.end();

      if (this.stops.some(function (stop) {
        return stop[2] < 1;
      })) {
        var grad = this.opacityGradient();
        grad._colorSpace = 'DeviceGray';

        var _iteratorNormalCompletion = true;
        var _didIteratorError = false;
        var _iteratorError = undefined;

        try {
          for (var _iterator = this.stops[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
            var stop = _step.value;

            grad.stop(stop[0], [stop[2]]);
          }
        } catch (err) {
          _didIteratorError = true;
          _iteratorError = err;
        } finally {
          try {
            if (!_iteratorNormalCompletion && _iterator.return) {
              _iterator.return();
            }
          } finally {
            if (_didIteratorError) {
              throw _iteratorError;
            }
          }
        }

        grad = grad.embed(this.matrix);

        var pageBBox = [0, 0, this.doc.page.width, this.doc.page.height];

        var form = this.doc.ref({
          Type: 'XObject',
          Subtype: 'Form',
          FormType: 1,
          BBox: pageBBox,
          Group: {
            Type: 'Group',
            S: 'Transparency',
            CS: 'DeviceGray'
          },
          Resources: {
            ProcSet: ['PDF', 'Text', 'ImageB', 'ImageC', 'ImageI'],
            Pattern: {
              Sh1: grad
            }
          }
        });

        form.write('/Pattern cs /Sh1 scn');
        form.end(pageBBox.join(' ') + ' re f');

        var gstate = this.doc.ref({
          Type: 'ExtGState',
          SMask: {
            Type: 'Mask',
            S: 'Luminosity',
            G: form
          }
        });

        gstate.end();

        var opacityPattern = this.doc.ref({
          Type: 'Pattern',
          PatternType: 1,
          PaintType: 1,
          TilingType: 2,
          BBox: pageBBox,
          XStep: pageBBox[2],
          YStep: pageBBox[3],
          Resources: {
            ProcSet: ['PDF', 'Text', 'ImageB', 'ImageC', 'ImageI'],
            Pattern: {
              Sh1: pattern
            },
            ExtGState: {
              Gs1: gstate
            }
          }
        });

        opacityPattern.write('/Gs1 gs /Pattern cs /Sh1 scn');
        opacityPattern.end(pageBBox.join(' ') + ' re f');

        this.doc.page.patterns[this.id] = opacityPattern;
      } else {
        this.doc.page.patterns[this.id] = pattern;
      }

      return pattern;
    }
  }, {
    key: 'apply',
    value: function apply(op) {
      // apply gradient transform to existing document ctm
      var _doc$_ctm = slicedToArray(this.doc._ctm, 6),
          m0 = _doc$_ctm[0],
          m1 = _doc$_ctm[1],
          m2 = _doc$_ctm[2],
          m3 = _doc$_ctm[3],
          m4 = _doc$_ctm[4],
          m5 = _doc$_ctm[5];

      var _transform = slicedToArray(this.transform, 6),
          m11 = _transform[0],
          m12 = _transform[1],
          m21 = _transform[2],
          m22 = _transform[3],
          dx = _transform[4],
          dy = _transform[5];

      var m = [m0 * m11 + m2 * m12, m1 * m11 + m3 * m12, m0 * m21 + m2 * m22, m1 * m21 + m3 * m22, m0 * dx + m2 * dy + m4, m1 * dx + m3 * dy + m5];

      if (!this.embedded || m.join(' ') !== this.matrix.join(' ')) {
        this.embed(m);
      }
      return this.doc.addContent('/' + this.id + ' ' + op);
    }
  }]);
  return PDFGradient;
}();

var PDFLinearGradient = function (_PDFGradient) {
  inherits(PDFLinearGradient, _PDFGradient);

  function PDFLinearGradient(doc, x1, y1, x2, y2) {
    classCallCheck(this, PDFLinearGradient);

    var _this = possibleConstructorReturn(this, (PDFLinearGradient.__proto__ || Object.getPrototypeOf(PDFLinearGradient)).call(this, doc));

    _this.x1 = x1;
    _this.y1 = y1;
    _this.x2 = x2;
    _this.y2 = y2;
    return _this;
  }

  createClass(PDFLinearGradient, [{
    key: 'shader',
    value: function shader(fn) {
      return this.doc.ref({
        ShadingType: 2,
        ColorSpace: this._colorSpace,
        Coords: [this.x1, this.y1, this.x2, this.y2],
        Function: fn,
        Extend: [true, true]
      });
    }
  }, {
    key: 'opacityGradient',
    value: function opacityGradient() {
      return new PDFLinearGradient(this.doc, this.x1, this.y1, this.x2, this.y2);
    }
  }]);
  return PDFLinearGradient;
}(PDFGradient);

var PDFRadialGradient = function (_PDFGradient2) {
  inherits(PDFRadialGradient, _PDFGradient2);

  function PDFRadialGradient(doc, x1, y1, r1, x2, y2, r2) {
    classCallCheck(this, PDFRadialGradient);

    var _this2 = possibleConstructorReturn(this, (PDFRadialGradient.__proto__ || Object.getPrototypeOf(PDFRadialGradient)).call(this, doc));

    _this2.doc = doc;
    _this2.x1 = x1;
    _this2.y1 = y1;
    _this2.r1 = r1;
    _this2.x2 = x2;
    _this2.y2 = y2;
    _this2.r2 = r2;
    return _this2;
  }

  createClass(PDFRadialGradient, [{
    key: 'shader',
    value: function shader(fn) {
      return this.doc.ref({
        ShadingType: 3,
        ColorSpace: this._colorSpace,
        Coords: [this.x1, this.y1, this.r1, this.x2, this.y2, this.r2],
        Function: fn,
        Extend: [true, true]
      });
    }
  }, {
    key: 'opacityGradient',
    value: function opacityGradient() {
      return new PDFRadialGradient(this.doc, this.x1, this.y1, this.r1, this.x2, this.y2, this.r2);
    }
  }]);
  return PDFRadialGradient;
}(PDFGradient);

var Gradient = { PDFGradient: PDFGradient, PDFLinearGradient: PDFLinearGradient, PDFRadialGradient: PDFRadialGradient };

var PDFGradient$1 = Gradient.PDFGradient,
    PDFLinearGradient$1 = Gradient.PDFLinearGradient,
    PDFRadialGradient$1 = Gradient.PDFRadialGradient;


var ColorMixin = {
  initColor: function initColor() {
    // The opacity dictionaries
    this._opacityRegistry = {};
    this._opacityCount = 0;
    return this._gradCount = 0;
  },
  _normalizeColor: function _normalizeColor(color) {
    if (color instanceof PDFGradient$1) {
      return color;
    }

    if (typeof color === 'string') {
      if (color.charAt(0) === '#') {
        if (color.length === 4) {
          color = color.replace(/#([0-9A-F])([0-9A-F])([0-9A-F])/i, '#$1$1$2$2$3$3');
        }
        var hex = parseInt(color.slice(1), 16);
        color = [hex >> 16, hex >> 8 & 0xff, hex & 0xff];
      } else if (namedColors[color]) {
        color = namedColors[color];
      }
    }

    if (Array.isArray(color)) {
      // RGB
      if (color.length === 3) {
        color = color.map(function (part) {
          return part / 255;
        });
        // CMYK
      } else if (color.length === 4) {
        color = color.map(function (part) {
          return part / 100;
        });
      }
      return color;
    }

    return null;
  },
  _setColor: function _setColor(color, stroke) {
    color = this._normalizeColor(color);
    if (!color) {
      return false;
    }

    var op = stroke ? 'SCN' : 'scn';

    if (color instanceof PDFGradient$1) {
      this._setColorSpace('Pattern', stroke);
      color.apply(op);
    } else {
      var space = color.length === 4 ? 'DeviceCMYK' : 'DeviceRGB';
      this._setColorSpace(space, stroke);

      color = color.join(' ');
      this.addContent(color + ' ' + op);
    }

    return true;
  },
  _setColorSpace: function _setColorSpace(space, stroke) {
    var op = stroke ? 'CS' : 'cs';
    return this.addContent('/' + space + ' ' + op);
  },
  fillColor: function fillColor(color, opacity) {
    var set$$1 = this._setColor(color, false);
    if (set$$1) {
      this.fillOpacity(opacity);
    }

    // save this for text wrapper, which needs to reset
    // the fill color on new pages
    this._fillColor = [color, opacity];
    return this;
  },
  strokeColor: function strokeColor(color, opacity) {
    var set$$1 = this._setColor(color, true);
    if (set$$1) {
      this.strokeOpacity(opacity);
    }
    return this;
  },
  opacity: function opacity(_opacity) {
    this._doOpacity(_opacity, _opacity);
    return this;
  },
  fillOpacity: function fillOpacity(opacity) {
    this._doOpacity(opacity, null);
    return this;
  },
  strokeOpacity: function strokeOpacity(opacity) {
    this._doOpacity(null, opacity);
    return this;
  },
  _doOpacity: function _doOpacity(fillOpacity, strokeOpacity) {
    var dictionary = void 0,
        name = void 0;
    if (fillOpacity == null && strokeOpacity == null) {
      return;
    }

    if (fillOpacity != null) {
      fillOpacity = Math.max(0, Math.min(1, fillOpacity));
    }
    if (strokeOpacity != null) {
      strokeOpacity = Math.max(0, Math.min(1, strokeOpacity));
    }
    var key = fillOpacity + '_' + strokeOpacity;

    if (this._opacityRegistry[key]) {
      var _opacityRegistry$key = slicedToArray(this._opacityRegistry[key], 2);

      dictionary = _opacityRegistry$key[0];
      name = _opacityRegistry$key[1];
    } else {
      dictionary = { Type: 'ExtGState' };

      if (fillOpacity != null) {
        dictionary.ca = fillOpacity;
      }
      if (strokeOpacity != null) {
        dictionary.CA = strokeOpacity;
      }

      dictionary = this.ref(dictionary);
      dictionary.end();
      var id = ++this._opacityCount;
      name = 'Gs' + id;
      this._opacityRegistry[key] = [dictionary, name];
    }

    this.page.ext_gstates[name] = dictionary;
    return this.addContent('/' + name + ' gs');
  },
  linearGradient: function linearGradient(x1, y1, x2, y2) {
    return new PDFLinearGradient$1(this, x1, y1, x2, y2);
  },
  radialGradient: function radialGradient(x1, y1, r1, x2, y2, r2) {
    return new PDFRadialGradient$1(this, x1, y1, r1, x2, y2, r2);
  }
};

var namedColors = {
  aliceblue: [240, 248, 255],
  antiquewhite: [250, 235, 215],
  aqua: [0, 255, 255],
  aquamarine: [127, 255, 212],
  azure: [240, 255, 255],
  beige: [245, 245, 220],
  bisque: [255, 228, 196],
  black: [0, 0, 0],
  blanchedalmond: [255, 235, 205],
  blue: [0, 0, 255],
  blueviolet: [138, 43, 226],
  brown: [165, 42, 42],
  burlywood: [222, 184, 135],
  cadetblue: [95, 158, 160],
  chartreuse: [127, 255, 0],
  chocolate: [210, 105, 30],
  coral: [255, 127, 80],
  cornflowerblue: [100, 149, 237],
  cornsilk: [255, 248, 220],
  crimson: [220, 20, 60],
  cyan: [0, 255, 255],
  darkblue: [0, 0, 139],
  darkcyan: [0, 139, 139],
  darkgoldenrod: [184, 134, 11],
  darkgray: [169, 169, 169],
  darkgreen: [0, 100, 0],
  darkgrey: [169, 169, 169],
  darkkhaki: [189, 183, 107],
  darkmagenta: [139, 0, 139],
  darkolivegreen: [85, 107, 47],
  darkorange: [255, 140, 0],
  darkorchid: [153, 50, 204],
  darkred: [139, 0, 0],
  darksalmon: [233, 150, 122],
  darkseagreen: [143, 188, 143],
  darkslateblue: [72, 61, 139],
  darkslategray: [47, 79, 79],
  darkslategrey: [47, 79, 79],
  darkturquoise: [0, 206, 209],
  darkviolet: [148, 0, 211],
  deeppink: [255, 20, 147],
  deepskyblue: [0, 191, 255],
  dimgray: [105, 105, 105],
  dimgrey: [105, 105, 105],
  dodgerblue: [30, 144, 255],
  firebrick: [178, 34, 34],
  floralwhite: [255, 250, 240],
  forestgreen: [34, 139, 34],
  fuchsia: [255, 0, 255],
  gainsboro: [220, 220, 220],
  ghostwhite: [248, 248, 255],
  gold: [255, 215, 0],
  goldenrod: [218, 165, 32],
  gray: [128, 128, 128],
  grey: [128, 128, 128],
  green: [0, 128, 0],
  greenyellow: [173, 255, 47],
  honeydew: [240, 255, 240],
  hotpink: [255, 105, 180],
  indianred: [205, 92, 92],
  indigo: [75, 0, 130],
  ivory: [255, 255, 240],
  khaki: [240, 230, 140],
  lavender: [230, 230, 250],
  lavenderblush: [255, 240, 245],
  lawngreen: [124, 252, 0],
  lemonchiffon: [255, 250, 205],
  lightblue: [173, 216, 230],
  lightcoral: [240, 128, 128],
  lightcyan: [224, 255, 255],
  lightgoldenrodyellow: [250, 250, 210],
  lightgray: [211, 211, 211],
  lightgreen: [144, 238, 144],
  lightgrey: [211, 211, 211],
  lightpink: [255, 182, 193],
  lightsalmon: [255, 160, 122],
  lightseagreen: [32, 178, 170],
  lightskyblue: [135, 206, 250],
  lightslategray: [119, 136, 153],
  lightslategrey: [119, 136, 153],
  lightsteelblue: [176, 196, 222],
  lightyellow: [255, 255, 224],
  lime: [0, 255, 0],
  limegreen: [50, 205, 50],
  linen: [250, 240, 230],
  magenta: [255, 0, 255],
  maroon: [128, 0, 0],
  mediumaquamarine: [102, 205, 170],
  mediumblue: [0, 0, 205],
  mediumorchid: [186, 85, 211],
  mediumpurple: [147, 112, 219],
  mediumseagreen: [60, 179, 113],
  mediumslateblue: [123, 104, 238],
  mediumspringgreen: [0, 250, 154],
  mediumturquoise: [72, 209, 204],
  mediumvioletred: [199, 21, 133],
  midnightblue: [25, 25, 112],
  mintcream: [245, 255, 250],
  mistyrose: [255, 228, 225],
  moccasin: [255, 228, 181],
  navajowhite: [255, 222, 173],
  navy: [0, 0, 128],
  oldlace: [253, 245, 230],
  olive: [128, 128, 0],
  olivedrab: [107, 142, 35],
  orange: [255, 165, 0],
  orangered: [255, 69, 0],
  orchid: [218, 112, 214],
  palegoldenrod: [238, 232, 170],
  palegreen: [152, 251, 152],
  paleturquoise: [175, 238, 238],
  palevioletred: [219, 112, 147],
  papayawhip: [255, 239, 213],
  peachpuff: [255, 218, 185],
  peru: [205, 133, 63],
  pink: [255, 192, 203],
  plum: [221, 160, 221],
  powderblue: [176, 224, 230],
  purple: [128, 0, 128],
  red: [255, 0, 0],
  rosybrown: [188, 143, 143],
  royalblue: [65, 105, 225],
  saddlebrown: [139, 69, 19],
  salmon: [250, 128, 114],
  sandybrown: [244, 164, 96],
  seagreen: [46, 139, 87],
  seashell: [255, 245, 238],
  sienna: [160, 82, 45],
  silver: [192, 192, 192],
  skyblue: [135, 206, 235],
  slateblue: [106, 90, 205],
  slategray: [112, 128, 144],
  slategrey: [112, 128, 144],
  snow: [255, 250, 250],
  springgreen: [0, 255, 127],
  steelblue: [70, 130, 180],
  tan: [210, 180, 140],
  teal: [0, 128, 128],
  thistle: [216, 191, 216],
  tomato: [255, 99, 71],
  turquoise: [64, 224, 208],
  violet: [238, 130, 238],
  wheat: [245, 222, 179],
  white: [255, 255, 255],
  whitesmoke: [245, 245, 245],
  yellow: [255, 255, 0],
  yellowgreen: [154, 205, 50]
};

var cx = void 0,
    cy = void 0,
    px = void 0,
    py = void 0,
    sx = void 0,
    sy = void 0;

cx = cy = px = py = sx = sy = 0;

var parameters = {
  A: 7,
  a: 7,
  C: 6,
  c: 6,
  H: 1,
  h: 1,
  L: 2,
  l: 2,
  M: 2,
  m: 2,
  Q: 4,
  q: 4,
  S: 4,
  s: 4,
  T: 2,
  t: 2,
  V: 1,
  v: 1,
  Z: 0,
  z: 0
};

var parse = function parse(path) {
  var cmd = void 0;
  var ret = [];
  var args = [];
  var curArg = '';
  var foundDecimal = false;
  var params = 0;

  var _iteratorNormalCompletion = true;
  var _didIteratorError = false;
  var _iteratorError = undefined;

  try {
    for (var _iterator = path[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
      var c = _step.value;

      if (parameters[c] != null) {
        params = parameters[c];
        if (cmd) {
          // save existing command
          if (curArg.length > 0) {
            args[args.length] = +curArg;
          }
          ret[ret.length] = { cmd: cmd, args: args };

          args = [];
          curArg = '';
          foundDecimal = false;
        }

        cmd = c;
      } else if ([' ', ','].includes(c) || c === '-' && curArg.length > 0 && curArg[curArg.length - 1] !== 'e' || c === '.' && foundDecimal) {
        if (curArg.length === 0) {
          continue;
        }

        if (args.length === params) {
          // handle reused commands
          ret[ret.length] = { cmd: cmd, args: args };
          args = [+curArg];

          // handle assumed commands
          if (cmd === 'M') {
            cmd = 'L';
          }
          if (cmd === 'm') {
            cmd = 'l';
          }
        } else {
          args[args.length] = +curArg;
        }

        foundDecimal = c === '.';

        // fix for negative numbers or repeated decimals with no delimeter between commands
        curArg = ['-', '.'].includes(c) ? c : '';
      } else {
        curArg += c;
        if (c === '.') {
          foundDecimal = true;
        }
      }
    }

    // add the last command
  } catch (err) {
    _didIteratorError = true;
    _iteratorError = err;
  } finally {
    try {
      if (!_iteratorNormalCompletion && _iterator.return) {
        _iterator.return();
      }
    } finally {
      if (_didIteratorError) {
        throw _iteratorError;
      }
    }
  }

  if (curArg.length > 0) {
    if (args.length === params) {
      // handle reused commands
      ret[ret.length] = { cmd: cmd, args: args };
      args = [+curArg];

      // handle assumed commands
      if (cmd === 'M') {
        cmd = 'L';
      }
      if (cmd === 'm') {
        cmd = 'l';
      }
    } else {
      args[args.length] = +curArg;
    }
  }

  ret[ret.length] = { cmd: cmd, args: args };

  return ret;
};

var _apply = function _apply(commands, doc) {
  // current point, control point, and subpath starting point
  cx = cy = px = py = sx = sy = 0;

  // run the commands
  for (var i = 0; i < commands.length; i++) {
    var c = commands[i];
    if (typeof runners[c.cmd] === 'function') {
      runners[c.cmd](doc, c.args);
    }
  }
};

var runners = {
  M: function M(doc, a) {
    cx = a[0];
    cy = a[1];
    px = py = null;
    sx = cx;
    sy = cy;
    return doc.moveTo(cx, cy);
  },
  m: function m(doc, a) {
    cx += a[0];
    cy += a[1];
    px = py = null;
    sx = cx;
    sy = cy;
    return doc.moveTo(cx, cy);
  },
  C: function C(doc, a) {
    cx = a[4];
    cy = a[5];
    px = a[2];
    py = a[3];
    return doc.bezierCurveTo.apply(doc, toConsumableArray(a || []));
  },
  c: function c(doc, a) {
    doc.bezierCurveTo(a[0] + cx, a[1] + cy, a[2] + cx, a[3] + cy, a[4] + cx, a[5] + cy);
    px = cx + a[2];
    py = cy + a[3];
    cx += a[4];
    return cy += a[5];
  },
  S: function S(doc, a) {
    if (px === null) {
      px = cx;
      py = cy;
    }

    doc.bezierCurveTo(cx - (px - cx), cy - (py - cy), a[0], a[1], a[2], a[3]);
    px = a[0];
    py = a[1];
    cx = a[2];
    return cy = a[3];
  },
  s: function s(doc, a) {
    if (px === null) {
      px = cx;
      py = cy;
    }

    doc.bezierCurveTo(cx - (px - cx), cy - (py - cy), cx + a[0], cy + a[1], cx + a[2], cy + a[3]);
    px = cx + a[0];
    py = cy + a[1];
    cx += a[2];
    return cy += a[3];
  },
  Q: function Q(doc, a) {
    px = a[0];
    py = a[1];
    cx = a[2];
    cy = a[3];
    return doc.quadraticCurveTo(a[0], a[1], cx, cy);
  },
  q: function q(doc, a) {
    doc.quadraticCurveTo(a[0] + cx, a[1] + cy, a[2] + cx, a[3] + cy);
    px = cx + a[0];
    py = cy + a[1];
    cx += a[2];
    return cy += a[3];
  },
  T: function T(doc, a) {
    if (px === null) {
      px = cx;
      py = cy;
    } else {
      px = cx - (px - cx);
      py = cy - (py - cy);
    }

    doc.quadraticCurveTo(px, py, a[0], a[1]);
    px = cx - (px - cx);
    py = cy - (py - cy);
    cx = a[0];
    return cy = a[1];
  },
  t: function t(doc, a) {
    if (px === null) {
      px = cx;
      py = cy;
    } else {
      px = cx - (px - cx);
      py = cy - (py - cy);
    }

    doc.quadraticCurveTo(px, py, cx + a[0], cy + a[1]);
    cx += a[0];
    return cy += a[1];
  },
  A: function A(doc, a) {
    solveArc(doc, cx, cy, a);
    cx = a[5];
    return cy = a[6];
  },
  a: function a(doc, _a) {
    _a[5] += cx;
    _a[6] += cy;
    solveArc(doc, cx, cy, _a);
    cx = _a[5];
    return cy = _a[6];
  },
  L: function L(doc, a) {
    cx = a[0];
    cy = a[1];
    px = py = null;
    return doc.lineTo(cx, cy);
  },
  l: function l(doc, a) {
    cx += a[0];
    cy += a[1];
    px = py = null;
    return doc.lineTo(cx, cy);
  },
  H: function H(doc, a) {
    cx = a[0];
    px = py = null;
    return doc.lineTo(cx, cy);
  },
  h: function h(doc, a) {
    cx += a[0];
    px = py = null;
    return doc.lineTo(cx, cy);
  },
  V: function V(doc, a) {
    cy = a[0];
    px = py = null;
    return doc.lineTo(cx, cy);
  },
  v: function v(doc, a) {
    cy += a[0];
    px = py = null;
    return doc.lineTo(cx, cy);
  },
  Z: function Z(doc) {
    doc.closePath();
    cx = sx;
    return cy = sy;
  },
  z: function z(doc) {
    doc.closePath();
    cx = sx;
    return cy = sy;
  }
};

var solveArc = function solveArc(doc, x, y, coords) {
  var _coords = slicedToArray(coords, 7),
      rx = _coords[0],
      ry = _coords[1],
      rot = _coords[2],
      large = _coords[3],
      sweep = _coords[4],
      ex = _coords[5],
      ey = _coords[6];

  var segs = arcToSegments(ex, ey, rx, ry, large, sweep, rot, x, y);

  var _iteratorNormalCompletion2 = true;
  var _didIteratorError2 = false;
  var _iteratorError2 = undefined;

  try {
    for (var _iterator2 = segs[Symbol.iterator](), _step2; !(_iteratorNormalCompletion2 = (_step2 = _iterator2.next()).done); _iteratorNormalCompletion2 = true) {
      var seg = _step2.value;

      var bez = segmentToBezier.apply(undefined, toConsumableArray(seg || []));
      doc.bezierCurveTo.apply(doc, toConsumableArray(bez || []));
    }
  } catch (err) {
    _didIteratorError2 = true;
    _iteratorError2 = err;
  } finally {
    try {
      if (!_iteratorNormalCompletion2 && _iterator2.return) {
        _iterator2.return();
      }
    } finally {
      if (_didIteratorError2) {
        throw _iteratorError2;
      }
    }
  }
};

// from Inkscape svgtopdf, thanks!
var arcToSegments = function arcToSegments(x, y, rx, ry, large, sweep, rotateX, ox, oy) {
  var th = rotateX * (Math.PI / 180);
  var sin_th = Math.sin(th);
  var cos_th = Math.cos(th);
  rx = Math.abs(rx);
  ry = Math.abs(ry);
  px = cos_th * (ox - x) * 0.5 + sin_th * (oy - y) * 0.5;
  py = cos_th * (oy - y) * 0.5 - sin_th * (ox - x) * 0.5;
  var pl = px * px / (rx * rx) + py * py / (ry * ry);
  if (pl > 1) {
    pl = Math.sqrt(pl);
    rx *= pl;
    ry *= pl;
  }

  var a00 = cos_th / rx;
  var a01 = sin_th / rx;
  var a10 = -sin_th / ry;
  var a11 = cos_th / ry;
  var x0 = a00 * ox + a01 * oy;
  var y0 = a10 * ox + a11 * oy;
  var x1 = a00 * x + a01 * y;
  var y1 = a10 * x + a11 * y;

  var d = (x1 - x0) * (x1 - x0) + (y1 - y0) * (y1 - y0);
  var sfactor_sq = 1 / d - 0.25;
  if (sfactor_sq < 0) {
    sfactor_sq = 0;
  }
  var sfactor = Math.sqrt(sfactor_sq);
  if (sweep === large) {
    sfactor = -sfactor;
  }

  var xc = 0.5 * (x0 + x1) - sfactor * (y1 - y0);
  var yc = 0.5 * (y0 + y1) + sfactor * (x1 - x0);

  var th0 = Math.atan2(y0 - yc, x0 - xc);
  var th1 = Math.atan2(y1 - yc, x1 - xc);

  var th_arc = th1 - th0;
  if (th_arc < 0 && sweep === 1) {
    th_arc += 2 * Math.PI;
  } else if (th_arc > 0 && sweep === 0) {
    th_arc -= 2 * Math.PI;
  }

  var segments = Math.ceil(Math.abs(th_arc / (Math.PI * 0.5 + 0.001)));
  var result = [];

  for (var i = 0, end = segments, asc = 0 <= end; asc ? i < end : i > end; asc ? i++ : i--) {
    var th2 = th0 + i * th_arc / segments;
    var th3 = th0 + (i + 1) * th_arc / segments;
    result[i] = [xc, yc, th2, th3, rx, ry, sin_th, cos_th];
  }

  return result;
};

var segmentToBezier = function segmentToBezier(cx, cy, th0, th1, rx, ry, sin_th, cos_th) {
  var a00 = cos_th * rx;
  var a01 = -sin_th * ry;
  var a10 = sin_th * rx;
  var a11 = cos_th * ry;

  var th_half = 0.5 * (th1 - th0);
  var t = 8 / 3 * Math.sin(th_half * 0.5) * Math.sin(th_half * 0.5) / Math.sin(th_half);
  var x1 = cx + Math.cos(th0) - t * Math.sin(th0);
  var y1 = cy + Math.sin(th0) + t * Math.cos(th0);
  var x3 = cx + Math.cos(th1);
  var y3 = cy + Math.sin(th1);
  var x2 = x3 + t * Math.sin(th1);
  var y2 = y3 - t * Math.cos(th1);

  return [a00 * x1 + a01 * y1, a10 * x1 + a11 * y1, a00 * x2 + a01 * y2, a10 * x2 + a11 * y2, a00 * x3 + a01 * y3, a10 * x3 + a11 * y3];
};

var SVGPath = function () {
  function SVGPath() {
    classCallCheck(this, SVGPath);
  }

  createClass(SVGPath, null, [{
    key: 'apply',
    value: function apply(doc, path) {
      var commands = parse(path);
      _apply(commands, doc);
    }
  }]);
  return SVGPath;
}();

var number$1 = PDFObject.number;

// This constant is used to approximate a symmetrical arc using a cubic
// Bezier curve.

var KAPPA = 4.0 * ((Math.sqrt(2) - 1.0) / 3.0);
var VectorMixin = {
  initVector: function initVector() {
    this._ctm = [1, 0, 0, 1, 0, 0]; // current transformation matrix
    return this._ctmStack = [];
  },
  save: function save() {
    this._ctmStack.push(this._ctm.slice());
    // TODO: save/restore colorspace and styles so not setting it unnessesarily all the time?
    return this.addContent('q');
  },
  restore: function restore() {
    this._ctm = this._ctmStack.pop() || [1, 0, 0, 1, 0, 0];
    return this.addContent('Q');
  },
  closePath: function closePath() {
    return this.addContent('h');
  },
  lineWidth: function lineWidth(w) {
    return this.addContent(number$1(w) + ' w');
  },


  _CAP_STYLES: {
    BUTT: 0,
    ROUND: 1,
    SQUARE: 2
  },

  lineCap: function lineCap(c) {
    if (typeof c === 'string') {
      c = this._CAP_STYLES[c.toUpperCase()];
    }
    return this.addContent(c + ' J');
  },


  _JOIN_STYLES: {
    MITER: 0,
    ROUND: 1,
    BEVEL: 2
  },

  lineJoin: function lineJoin(j) {
    if (typeof j === 'string') {
      j = this._JOIN_STYLES[j.toUpperCase()];
    }
    return this.addContent(j + ' j');
  },
  miterLimit: function miterLimit(m) {
    return this.addContent(number$1(m) + ' M');
  },
  dash: function dash(length, options) {
    var phase = void 0;
    if (options == null) {
      options = {};
    }
    if (length == null) {
      return this;
    }
    if (Array.isArray(length)) {
      length = length.map(function (v) {
        return number$1(v);
      }).join(' ');
      phase = options.phase || 0;
      return this.addContent('[' + length + '] ' + number$1(phase) + ' d');
    } else {
      var space = options.space != null ? options.space : length;
      phase = options.phase || 0;
      return this.addContent('[' + number$1(length) + ' ' + number$1(space) + '] ' + number$1(phase) + ' d');
    }
  },
  undash: function undash() {
    return this.addContent('[] 0 d');
  },
  moveTo: function moveTo(x, y) {
    return this.addContent(number$1(x) + ' ' + number$1(y) + ' m');
  },
  lineTo: function lineTo(x, y) {
    return this.addContent(number$1(x) + ' ' + number$1(y) + ' l');
  },
  bezierCurveTo: function bezierCurveTo(cp1x, cp1y, cp2x, cp2y, x, y) {
    return this.addContent(number$1(cp1x) + ' ' + number$1(cp1y) + ' ' + number$1(cp2x) + ' ' + number$1(cp2y) + ' ' + number$1(x) + ' ' + number$1(y) + ' c');
  },
  quadraticCurveTo: function quadraticCurveTo(cpx, cpy, x, y) {
    return this.addContent(number$1(cpx) + ' ' + number$1(cpy) + ' ' + number$1(x) + ' ' + number$1(y) + ' v');
  },
  rect: function rect(x, y, w, h) {
    return this.addContent(number$1(x) + ' ' + number$1(y) + ' ' + number$1(w) + ' ' + number$1(h) + ' re');
  },
  roundedRect: function roundedRect(x, y, w, h, r) {
    if (r == null) {
      r = 0;
    }
    r = Math.min(r, 0.5 * w, 0.5 * h);

    // amount to inset control points from corners (see `ellipse`)
    var c = r * (1.0 - KAPPA);

    this.moveTo(x + r, y);
    this.lineTo(x + w - r, y);
    this.bezierCurveTo(x + w - c, y, x + w, y + c, x + w, y + r);
    this.lineTo(x + w, y + h - r);
    this.bezierCurveTo(x + w, y + h - c, x + w - c, y + h, x + w - r, y + h);
    this.lineTo(x + r, y + h);
    this.bezierCurveTo(x + c, y + h, x, y + h - c, x, y + h - r);
    this.lineTo(x, y + r);
    this.bezierCurveTo(x, y + c, x + c, y, x + r, y);
    return this.closePath();
  },
  ellipse: function ellipse(x, y, r1, r2) {
    // based on http://stackoverflow.com/questions/2172798/how-to-draw-an-oval-in-html5-canvas/2173084#2173084
    if (r2 == null) {
      r2 = r1;
    }
    x -= r1;
    y -= r2;
    var ox = r1 * KAPPA;
    var oy = r2 * KAPPA;
    var xe = x + r1 * 2;
    var ye = y + r2 * 2;
    var xm = x + r1;
    var ym = y + r2;

    this.moveTo(x, ym);
    this.bezierCurveTo(x, ym - oy, xm - ox, y, xm, y);
    this.bezierCurveTo(xm + ox, y, xe, ym - oy, xe, ym);
    this.bezierCurveTo(xe, ym + oy, xm + ox, ye, xm, ye);
    this.bezierCurveTo(xm - ox, ye, x, ym + oy, x, ym);
    return this.closePath();
  },
  circle: function circle(x, y, radius) {
    return this.ellipse(x, y, radius);
  },
  arc: function arc(x, y, radius, startAngle, endAngle, anticlockwise) {
    if (anticlockwise == null) {
      anticlockwise = false;
    }
    var TWO_PI = 2.0 * Math.PI;
    var HALF_PI = 0.5 * Math.PI;

    var deltaAng = endAngle - startAngle;

    if (Math.abs(deltaAng) > TWO_PI) {
      // draw only full circle if more than that is specified
      deltaAng = TWO_PI;
    } else if (deltaAng !== 0 && anticlockwise !== deltaAng < 0) {
      // necessary to flip direction of rendering
      var dir = anticlockwise ? -1 : 1;
      deltaAng = dir * TWO_PI + deltaAng;
    }

    var numSegs = Math.ceil(Math.abs(deltaAng) / HALF_PI);
    var segAng = deltaAng / numSegs;
    var handleLen = segAng / HALF_PI * KAPPA * radius;
    var curAng = startAngle;

    // component distances between anchor point and control point
    var deltaCx = -Math.sin(curAng) * handleLen;
    var deltaCy = Math.cos(curAng) * handleLen;

    // anchor point
    var ax = x + Math.cos(curAng) * radius;
    var ay = y + Math.sin(curAng) * radius;

    // calculate and render segments
    this.moveTo(ax, ay);

    for (var segIdx = 0, end = numSegs, asc = 0 <= end; asc ? segIdx < end : segIdx > end; asc ? segIdx++ : segIdx--) {
      // starting control point
      var cp1x = ax + deltaCx;
      var cp1y = ay + deltaCy;

      // step angle
      curAng += segAng;

      // next anchor point
      ax = x + Math.cos(curAng) * radius;
      ay = y + Math.sin(curAng) * radius;

      // next control point delta
      deltaCx = -Math.sin(curAng) * handleLen;
      deltaCy = Math.cos(curAng) * handleLen;

      // ending control point
      var cp2x = ax - deltaCx;
      var cp2y = ay - deltaCy;

      // render segment
      this.bezierCurveTo(cp1x, cp1y, cp2x, cp2y, ax, ay);
    }

    return this;
  },
  polygon: function polygon() {
    for (var _len = arguments.length, points = Array(_len), _key = 0; _key < _len; _key++) {
      points[_key] = arguments[_key];
    }

    this.moveTo.apply(this, toConsumableArray(points.shift() || []));
    var _iteratorNormalCompletion = true;
    var _didIteratorError = false;
    var _iteratorError = undefined;

    try {
      for (var _iterator = points[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
        var point = _step.value;

        this.lineTo.apply(this, toConsumableArray(point || []));
      }
    } catch (err) {
      _didIteratorError = true;
      _iteratorError = err;
    } finally {
      try {
        if (!_iteratorNormalCompletion && _iterator.return) {
          _iterator.return();
        }
      } finally {
        if (_didIteratorError) {
          throw _iteratorError;
        }
      }
    }

    return this.closePath();
  },
  path: function path(_path) {
    SVGPath.apply(this, _path);
    return this;
  },
  _windingRule: function _windingRule(rule) {
    if (/even-?odd/.test(rule)) {
      return '*';
    }

    return '';
  },
  fill: function fill(color, rule) {
    if (/(even-?odd)|(non-?zero)/.test(color)) {
      rule = color;
      color = null;
    }

    if (color) {
      this.fillColor(color);
    }
    return this.addContent('f' + this._windingRule(rule));
  },
  stroke: function stroke(color) {
    if (color) {
      this.strokeColor(color);
    }
    return this.addContent('S');
  },
  fillAndStroke: function fillAndStroke(fillColor, strokeColor, rule) {
    if (strokeColor == null) {
      strokeColor = fillColor;
    }
    var isFillRule = /(even-?odd)|(non-?zero)/;
    if (isFillRule.test(fillColor)) {
      rule = fillColor;
      fillColor = null;
    }

    if (isFillRule.test(strokeColor)) {
      rule = strokeColor;
      strokeColor = fillColor;
    }

    if (fillColor) {
      this.fillColor(fillColor);
      this.strokeColor(strokeColor);
    }

    return this.addContent('B' + this._windingRule(rule));
  },
  clip: function clip(rule) {
    return this.addContent('W' + this._windingRule(rule) + ' n');
  },
  transform: function transform(m11, m12, m21, m22, dx, dy) {
    // keep track of the current transformation matrix
    var m = this._ctm;

    var _m = slicedToArray(m, 6),
        m0 = _m[0],
        m1 = _m[1],
        m2 = _m[2],
        m3 = _m[3],
        m4 = _m[4],
        m5 = _m[5];

    m[0] = m0 * m11 + m2 * m12;
    m[1] = m1 * m11 + m3 * m12;
    m[2] = m0 * m21 + m2 * m22;
    m[3] = m1 * m21 + m3 * m22;
    m[4] = m0 * dx + m2 * dy + m4;
    m[5] = m1 * dx + m3 * dy + m5;

    var values = [m11, m12, m21, m22, dx, dy].map(function (v) {
      return number$1(v);
    }).join(' ');
    return this.addContent(values + ' cm');
  },
  translate: function translate(x, y) {
    return this.transform(1, 0, 0, 1, x, y);
  },
  rotate: function rotate(angle, options) {
    var y = void 0;
    if (options == null) {
      options = {};
    }
    var rad = angle * Math.PI / 180;
    var cos = Math.cos(rad);
    var sin = Math.sin(rad);
    var x = y = 0;

    if (options.origin != null) {
      var _options$origin = slicedToArray(options.origin, 2);

      x = _options$origin[0];
      y = _options$origin[1];

      var x1 = x * cos - y * sin;
      var y1 = x * sin + y * cos;
      x -= x1;
      y -= y1;
    }

    return this.transform(cos, sin, -sin, cos, x, y);
  },
  scale: function scale(xFactor, yFactor, options) {
    var y = void 0;
    if (yFactor == null) {
      yFactor = xFactor;
    }
    if (options == null) {
      options = {};
    }
    if ((typeof yFactor === 'undefined' ? 'undefined' : _typeof(yFactor)) === 'object') {
      options = yFactor;
      yFactor = xFactor;
    }

    var x = y = 0;
    if (options.origin != null) {
      var _options$origin2 = slicedToArray(options.origin, 2);

      x = _options$origin2[0];
      y = _options$origin2[1];

      x -= xFactor * x;
      y -= yFactor * y;
    }

    return this.transform(xFactor, 0, 0, yFactor, x, y);
  }
};

var WIN_ANSI_MAP = {
  402: 131,
  8211: 150,
  8212: 151,
  8216: 145,
  8217: 146,
  8218: 130,
  8220: 147,
  8221: 148,
  8222: 132,
  8224: 134,
  8225: 135,
  8226: 149,
  8230: 133,
  8364: 128,
  8240: 137,
  8249: 139,
  8250: 155,
  710: 136,
  8482: 153,
  338: 140,
  339: 156,
  732: 152,
  352: 138,
  353: 154,
  376: 159,
  381: 142,
  382: 158
};

var characters = '.notdef       .notdef        .notdef        .notdef\n.notdef       .notdef        .notdef        .notdef\n.notdef       .notdef        .notdef        .notdef\n.notdef       .notdef        .notdef        .notdef\n.notdef       .notdef        .notdef        .notdef\n.notdef       .notdef        .notdef        .notdef\n.notdef       .notdef        .notdef        .notdef\n.notdef       .notdef        .notdef        .notdef\n  \nspace         exclam         quotedbl       numbersign\ndollar        percent        ampersand      quotesingle\nparenleft     parenright     asterisk       plus\ncomma         hyphen         period         slash\nzero          one            two            three\nfour          five           six            seven\neight         nine           colon          semicolon\nless          equal          greater        question\n  \nat            A              B              C\nD             E              F              G\nH             I              J              K\nL             M              N              O\nP             Q              R              S\nT             U              V              W\nX             Y              Z              bracketleft\nbackslash     bracketright   asciicircum    underscore\n  \ngrave         a              b              c\nd             e              f              g\nh             i              j              k\nl             m              n              o\np             q              r              s\nt             u              v              w\nx             y              z              braceleft\nbar           braceright     asciitilde     .notdef\n  \nEuro          .notdef        quotesinglbase florin\nquotedblbase  ellipsis       dagger         daggerdbl\ncircumflex    perthousand    Scaron         guilsinglleft\nOE            .notdef        Zcaron         .notdef\n.notdef       quoteleft      quoteright     quotedblleft\nquotedblright bullet         endash         emdash\ntilde         trademark      scaron         guilsinglright\noe            .notdef        zcaron         ydieresis\n  \nspace         exclamdown     cent           sterling\ncurrency      yen            brokenbar      section\ndieresis      copyright      ordfeminine    guillemotleft\nlogicalnot    hyphen         registered     macron\ndegree        plusminus      twosuperior    threesuperior\nacute         mu             paragraph      periodcentered\ncedilla       onesuperior    ordmasculine   guillemotright\nonequarter    onehalf        threequarters  questiondown\n  \nAgrave        Aacute         Acircumflex    Atilde\nAdieresis     Aring          AE             Ccedilla\nEgrave        Eacute         Ecircumflex    Edieresis\nIgrave        Iacute         Icircumflex    Idieresis\nEth           Ntilde         Ograve         Oacute\nOcircumflex   Otilde         Odieresis      multiply\nOslash        Ugrave         Uacute         Ucircumflex\nUdieresis     Yacute         Thorn          germandbls\n  \nagrave        aacute         acircumflex    atilde\nadieresis     aring          ae             ccedilla\negrave        eacute         ecircumflex    edieresis\nigrave        iacute         icircumflex    idieresis\neth           ntilde         ograve         oacute\nocircumflex   otilde         odieresis      divide\noslash        ugrave         uacute         ucircumflex\nudieresis     yacute         thorn          ydieresis'.split(/\s+/);

var AFMFont = function () {
  createClass(AFMFont, null, [{
    key: 'open',
    value: function open(filename) {
      return new AFMFont(fs.readFileSync(filename, 'utf8'));
    }
  }]);

  function AFMFont(contents) {
    classCallCheck(this, AFMFont);

    this.contents = contents;
    this.attributes = {};
    this.glyphWidths = {};
    this.boundingBoxes = {};
    this.kernPairs = {};

    this.parse();
    // todo: remove charWidths since appears to not be used
    this.charWidths = new Array(256);
    for (var char = 0; char <= 255; char++) {
      this.charWidths[char] = this.glyphWidths[characters[char]];
    }

    this.bbox = this.attributes['FontBBox'].split(/\s+/).map(function (e) {
      return +e;
    });
    this.ascender = +(this.attributes['Ascender'] || 0);
    this.descender = +(this.attributes['Descender'] || 0);
    this.xHeight = +(this.attributes['XHeight'] || 0);
    this.capHeight = +(this.attributes['CapHeight'] || 0);
    this.lineGap = this.bbox[3] - this.bbox[1] - (this.ascender - this.descender);
  }

  createClass(AFMFont, [{
    key: 'parse',
    value: function parse() {
      var section = '';
      var _iteratorNormalCompletion = true;
      var _didIteratorError = false;
      var _iteratorError = undefined;

      try {
        for (var _iterator = this.contents.split('\n')[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
          var line = _step.value;

          var match;
          var a;
          if (match = line.match(/^Start(\w+)/)) {
            section = match[1];
            continue;
          } else if (match = line.match(/^End(\w+)/)) {
            section = '';
            continue;
          }

          switch (section) {
            case 'FontMetrics':
              match = line.match(/(^\w+)\s+(.*)/);
              var key = match[1];
              var value = match[2];

              if (a = this.attributes[key]) {
                if (!Array.isArray(a)) {
                  a = this.attributes[key] = [a];
                }
                a.push(value);
              } else {
                this.attributes[key] = value;
              }
              break;

            case 'CharMetrics':
              if (!/^CH?\s/.test(line)) {
                continue;
              }
              var name = line.match(/\bN\s+(\.?\w+)\s*;/)[1];
              this.glyphWidths[name] = +line.match(/\bWX\s+(\d+)\s*;/)[1];
              break;

            case 'KernPairs':
              match = line.match(/^KPX\s+(\.?\w+)\s+(\.?\w+)\s+(-?\d+)/);
              if (match) {
                this.kernPairs[match[1] + '\0' + match[2]] = parseInt(match[3]);
              }
              break;
          }
        }
      } catch (err) {
        _didIteratorError = true;
        _iteratorError = err;
      } finally {
        try {
          if (!_iteratorNormalCompletion && _iterator.return) {
            _iterator.return();
          }
        } finally {
          if (_didIteratorError) {
            throw _iteratorError;
          }
        }
      }
    }
  }, {
    key: 'encodeText',
    value: function encodeText(text) {
      var res = [];
      for (var i = 0, end = text.length, asc = 0 <= end; asc ? i < end : i > end; asc ? i++ : i--) {
        var char = text.charCodeAt(i);
        char = WIN_ANSI_MAP[char] || char;
        res.push(char.toString(16));
      }

      return res;
    }
  }, {
    key: 'glyphsForString',
    value: function glyphsForString(string) {
      var glyphs = [];

      for (var i = 0, end = string.length, asc = 0 <= end; asc ? i < end : i > end; asc ? i++ : i--) {
        var charCode = string.charCodeAt(i);
        glyphs.push(this.characterToGlyph(charCode));
      }

      return glyphs;
    }
  }, {
    key: 'characterToGlyph',
    value: function characterToGlyph(character) {
      return characters[WIN_ANSI_MAP[character] || character] || '.notdef';
    }
  }, {
    key: 'widthOfGlyph',
    value: function widthOfGlyph(glyph) {
      return this.glyphWidths[glyph] || 0;
    }
  }, {
    key: 'getKernPair',
    value: function getKernPair(left, right) {
      return this.kernPairs[left + '\0' + right] || 0;
    }
  }, {
    key: 'advancesForGlyphs',
    value: function advancesForGlyphs(glyphs) {
      var advances = [];

      for (var index = 0; index < glyphs.length; index++) {
        var left = glyphs[index];
        var right = glyphs[index + 1];
        advances.push(this.widthOfGlyph(left) + this.getKernPair(left, right));
      }

      return advances;
    }
  }]);
  return AFMFont;
}();

var PDFFont = function () {
  function PDFFont() {
    classCallCheck(this, PDFFont);
  }

  createClass(PDFFont, [{
    key: 'encode',
    value: function encode() {
      throw new Error('Must be implemented by subclasses');
    }
  }, {
    key: 'widthOfString',
    value: function widthOfString() {
      throw new Error('Must be implemented by subclasses');
    }
  }, {
    key: 'ref',
    value: function ref() {
      return this.dictionary != null ? this.dictionary : this.dictionary = this.document.ref();
    }
  }, {
    key: 'finalize',
    value: function finalize() {
      if (this.embedded || this.dictionary == null) {
        return;
      }

      this.embed();
      return this.embedded = true;
    }
  }, {
    key: 'embed',
    value: function embed() {
      throw new Error('Must be implemented by subclasses');
    }
  }, {
    key: 'lineHeight',
    value: function lineHeight(size, includeGap) {
      if (includeGap == null) {
        includeGap = false;
      }
      var gap = includeGap ? this.lineGap : 0;
      return (this.ascender + gap - this.descender) / 1000 * size;
    }
  }]);
  return PDFFont;
}();

// This insanity is so bundlers can inline the font files
var STANDARD_FONTS = {
  Courier: function Courier() {
    return fs.readFileSync(__dirname + '/data/Courier.afm', 'utf8');
  },
  'Courier-Bold': function CourierBold() {
    return fs.readFileSync(__dirname + '/data/Courier-Bold.afm', 'utf8');
  },
  'Courier-Oblique': function CourierOblique() {
    return fs.readFileSync(__dirname + '/data/Courier-Oblique.afm', 'utf8');
  },
  'Courier-BoldOblique': function CourierBoldOblique() {
    return fs.readFileSync(__dirname + '/data/Courier-BoldOblique.afm', 'utf8');
  },
  Helvetica: function Helvetica() {
    return fs.readFileSync(__dirname + '/data/Helvetica.afm', 'utf8');
  },
  'Helvetica-Bold': function HelveticaBold() {
    return fs.readFileSync(__dirname + '/data/Helvetica-Bold.afm', 'utf8');
  },
  'Helvetica-Oblique': function HelveticaOblique() {
    return fs.readFileSync(__dirname + '/data/Helvetica-Oblique.afm', 'utf8');
  },
  'Helvetica-BoldOblique': function HelveticaBoldOblique() {
    return fs.readFileSync(__dirname + '/data/Helvetica-BoldOblique.afm', 'utf8');
  },
  'Times-Roman': function TimesRoman() {
    return fs.readFileSync(__dirname + '/data/Times-Roman.afm', 'utf8');
  },
  'Times-Bold': function TimesBold() {
    return fs.readFileSync(__dirname + '/data/Times-Bold.afm', 'utf8');
  },
  'Times-Italic': function TimesItalic() {
    return fs.readFileSync(__dirname + '/data/Times-Italic.afm', 'utf8');
  },
  'Times-BoldItalic': function TimesBoldItalic() {
    return fs.readFileSync(__dirname + '/data/Times-BoldItalic.afm', 'utf8');
  },
  Symbol: function Symbol() {
    return fs.readFileSync(__dirname + '/data/Symbol.afm', 'utf8');
  },
  ZapfDingbats: function ZapfDingbats() {
    return fs.readFileSync(__dirname + '/data/ZapfDingbats.afm', 'utf8');
  }
};

var StandardFont = function (_PDFFont) {
  inherits(StandardFont, _PDFFont);

  function StandardFont(document, name, id) {
    classCallCheck(this, StandardFont);

    var _this = possibleConstructorReturn(this, (StandardFont.__proto__ || Object.getPrototypeOf(StandardFont)).call(this));

    _this.document = document;
    _this.name = name;
    _this.id = id;
    _this.font = new AFMFont(STANDARD_FONTS[_this.name]());
    var _this$font = _this.font;
    _this.ascender = _this$font.ascender;
    _this.descender = _this$font.descender;
    _this.bbox = _this$font.bbox;
    _this.lineGap = _this$font.lineGap;
    _this.xHeight = _this$font.xHeight;
    _this.capHeight = _this$font.capHeight;
    return _this;
  }

  createClass(StandardFont, [{
    key: 'embed',
    value: function embed() {
      this.dictionary.data = {
        Type: 'Font',
        BaseFont: this.name,
        Subtype: 'Type1',
        Encoding: 'WinAnsiEncoding'
      };

      return this.dictionary.end();
    }
  }, {
    key: 'encode',
    value: function encode(text) {
      var encoded = this.font.encodeText(text);
      var glyphs = this.font.glyphsForString('' + text);
      var advances = this.font.advancesForGlyphs(glyphs);
      var positions = [];
      for (var i = 0; i < glyphs.length; i++) {
        var glyph = glyphs[i];
        positions.push({
          xAdvance: advances[i],
          yAdvance: 0,
          xOffset: 0,
          yOffset: 0,
          advanceWidth: this.font.widthOfGlyph(glyph)
        });
      }

      return [encoded, positions];
    }
  }, {
    key: 'widthOfString',
    value: function widthOfString(string, size) {
      var glyphs = this.font.glyphsForString('' + string);
      var advances = this.font.advancesForGlyphs(glyphs);

      var width = 0;
      var _iteratorNormalCompletion = true;
      var _didIteratorError = false;
      var _iteratorError = undefined;

      try {
        for (var _iterator = advances[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
          var advance = _step.value;

          width += advance;
        }
      } catch (err) {
        _didIteratorError = true;
        _iteratorError = err;
      } finally {
        try {
          if (!_iteratorNormalCompletion && _iterator.return) {
            _iterator.return();
          }
        } finally {
          if (_didIteratorError) {
            throw _iteratorError;
          }
        }
      }

      var scale = size / 1000;
      return width * scale;
    }
  }], [{
    key: 'isStandardFont',
    value: function isStandardFont(name) {
      return name in STANDARD_FONTS;
    }
  }]);
  return StandardFont;
}(PDFFont);

var toHex = function toHex(num) {
  return ('0000' + num.toString(16)).slice(-4);
};

var EmbeddedFont = function (_PDFFont) {
  inherits(EmbeddedFont, _PDFFont);

  function EmbeddedFont(document, font, id) {
    classCallCheck(this, EmbeddedFont);

    var _this = possibleConstructorReturn(this, (EmbeddedFont.__proto__ || Object.getPrototypeOf(EmbeddedFont)).call(this));

    _this.document = document;
    _this.font = font;
    _this.id = id;
    _this.subset = _this.font.createSubset();
    _this.unicode = [[0]];
    _this.widths = [_this.font.getGlyph(0).advanceWidth];

    _this.name = _this.font.postscriptName;
    _this.scale = 1000 / _this.font.unitsPerEm;
    _this.ascender = _this.font.ascent * _this.scale;
    _this.descender = _this.font.descent * _this.scale;
    _this.xHeight = _this.font.xHeight * _this.scale;
    _this.capHeight = _this.font.capHeight * _this.scale;
    _this.lineGap = _this.font.lineGap * _this.scale;
    _this.bbox = _this.font.bbox;

    _this.layoutCache = Object.create(null);
    return _this;
  }

  createClass(EmbeddedFont, [{
    key: 'layoutRun',
    value: function layoutRun(text, features) {
      var run = this.font.layout(text, features);

      // Normalize position values
      for (var i = 0; i < run.positions.length; i++) {
        var position = run.positions[i];
        for (var key in position) {
          position[key] *= this.scale;
        }

        position.advanceWidth = run.glyphs[i].advanceWidth * this.scale;
      }

      return run;
    }
  }, {
    key: 'layoutCached',
    value: function layoutCached(text) {
      var cached = void 0;
      if (cached = this.layoutCache[text]) {
        return cached;
      }

      var run = this.layoutRun(text);
      this.layoutCache[text] = run;
      return run;
    }
  }, {
    key: 'layout',
    value: function layout(text, features, onlyWidth) {
      // Skip the cache if any user defined features are applied
      if (onlyWidth == null) {
        onlyWidth = false;
      }
      if (features) {
        return this.layoutRun(text, features);
      }

      var glyphs = onlyWidth ? null : [];
      var positions = onlyWidth ? null : [];
      var advanceWidth = 0;

      // Split the string by words to increase cache efficiency.
      // For this purpose, spaces and tabs are a good enough delimeter.
      var last = 0;
      var index = 0;
      while (index <= text.length) {
        var needle;
        if (index === text.length && last < index || (needle = text.charAt(index), [' ', '\t'].includes(needle))) {
          var run = this.layoutCached(text.slice(last, ++index));
          if (!onlyWidth) {
            glyphs.push.apply(glyphs, toConsumableArray(run.glyphs || []));
            positions.push.apply(positions, toConsumableArray(run.positions || []));
          }

          advanceWidth += run.advanceWidth;
          last = index;
        } else {
          index++;
        }
      }

      return { glyphs: glyphs, positions: positions, advanceWidth: advanceWidth };
    }
  }, {
    key: 'encode',
    value: function encode(text, features) {
      var _layout = this.layout(text, features),
          glyphs = _layout.glyphs,
          positions = _layout.positions;

      var res = [];
      for (var i = 0; i < glyphs.length; i++) {
        var glyph = glyphs[i];
        var gid = this.subset.includeGlyph(glyph.id);
        res.push(('0000' + gid.toString(16)).slice(-4));

        if (this.widths[gid] == null) {
          this.widths[gid] = glyph.advanceWidth * this.scale;
        }
        if (this.unicode[gid] == null) {
          this.unicode[gid] = glyph.codePoints;
        }
      }

      return [res, positions];
    }
  }, {
    key: 'widthOfString',
    value: function widthOfString(string, size, features) {
      var width = this.layout(string, features, true).advanceWidth;
      var scale = size / 1000;
      return width * scale;
    }
  }, {
    key: 'embed',
    value: function embed() {
      var _this2 = this;

      var isCFF = this.subset.cff != null;
      var fontFile = this.document.ref();

      if (isCFF) {
        fontFile.data.Subtype = 'CIDFontType0C';
      }

      this.subset.encodeStream().on('data', function (data) {
        return fontFile.write(data);
      }).on('end', function () {
        return fontFile.end();
      });

      var familyClass = ((this.font['OS/2'] != null ? this.font['OS/2'].sFamilyClass : undefined) || 0) >> 8;
      var flags = 0;
      if (this.font.post.isFixedPitch) {
        flags |= 1 << 0;
      }
      if (1 <= familyClass && familyClass <= 7) {
        flags |= 1 << 1;
      }
      flags |= 1 << 2; // assume the font uses non-latin characters
      if (familyClass === 10) {
        flags |= 1 << 3;
      }
      if (this.font.head.macStyle.italic) {
        flags |= 1 << 6;
      }

      // generate a tag (6 uppercase letters. 16 is the char code offset from '1' to 'A'. 74 will map to 'Z')
      var tag = [1, 2, 3, 4, 5, 6].map(function (i) {
        return String.fromCharCode((_this2.id.charCodeAt(i) || 74) + 16);
      }).join('');
      var name = tag + '+' + this.font.postscriptName;

      var bbox = this.font.bbox;

      var descriptor = this.document.ref({
        Type: 'FontDescriptor',
        FontName: name,
        Flags: flags,
        FontBBox: [bbox.minX * this.scale, bbox.minY * this.scale, bbox.maxX * this.scale, bbox.maxY * this.scale],
        ItalicAngle: this.font.italicAngle,
        Ascent: this.ascender,
        Descent: this.descender,
        CapHeight: (this.font.capHeight || this.font.ascent) * this.scale,
        XHeight: (this.font.xHeight || 0) * this.scale,
        StemV: 0
      }); // not sure how to calculate this

      if (isCFF) {
        descriptor.data.FontFile3 = fontFile;
      } else {
        descriptor.data.FontFile2 = fontFile;
      }

      descriptor.end();

      var descendantFont = this.document.ref({
        Type: 'Font',
        Subtype: isCFF ? 'CIDFontType0' : 'CIDFontType2',
        BaseFont: name,
        CIDSystemInfo: {
          Registry: new String('Adobe'),
          Ordering: new String('Identity'),
          Supplement: 0
        },
        FontDescriptor: descriptor,
        W: [0, this.widths]
      });

      descendantFont.end();

      this.dictionary.data = {
        Type: 'Font',
        Subtype: 'Type0',
        BaseFont: name,
        Encoding: 'Identity-H',
        DescendantFonts: [descendantFont],
        ToUnicode: this.toUnicodeCmap()
      };

      return this.dictionary.end();
    }

    // Maps the glyph ids encoded in the PDF back to unicode strings
    // Because of ligature substitutions and the like, there may be one or more
    // unicode characters represented by each glyph.

  }, {
    key: 'toUnicodeCmap',
    value: function toUnicodeCmap() {
      var cmap = this.document.ref();

      var entries = [];
      var _iteratorNormalCompletion = true;
      var _didIteratorError = false;
      var _iteratorError = undefined;

      try {
        for (var _iterator = this.unicode[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
          var codePoints = _step.value;

          var encoded = [];

          // encode codePoints to utf16
          var _iteratorNormalCompletion2 = true;
          var _didIteratorError2 = false;
          var _iteratorError2 = undefined;

          try {
            for (var _iterator2 = codePoints[Symbol.iterator](), _step2; !(_iteratorNormalCompletion2 = (_step2 = _iterator2.next()).done); _iteratorNormalCompletion2 = true) {
              var value = _step2.value;

              if (value > 0xffff) {
                value -= 0x10000;
                encoded.push(toHex(value >>> 10 & 0x3ff | 0xd800));
                value = 0xdc00 | value & 0x3ff;
              }

              encoded.push(toHex(value));
            }
          } catch (err) {
            _didIteratorError2 = true;
            _iteratorError2 = err;
          } finally {
            try {
              if (!_iteratorNormalCompletion2 && _iterator2.return) {
                _iterator2.return();
              }
            } finally {
              if (_didIteratorError2) {
                throw _iteratorError2;
              }
            }
          }

          entries.push('<' + encoded.join(' ') + '>');
        }
      } catch (err) {
        _didIteratorError = true;
        _iteratorError = err;
      } finally {
        try {
          if (!_iteratorNormalCompletion && _iterator.return) {
            _iterator.return();
          }
        } finally {
          if (_didIteratorError) {
            throw _iteratorError;
          }
        }
      }

      cmap.end('/CIDInit /ProcSet findresource begin\n12 dict begin\nbegincmap\n/CIDSystemInfo <<\n  /Registry (Adobe)\n  /Ordering (UCS)\n  /Supplement 0\n>> def\n/CMapName /Adobe-Identity-UCS def\n/CMapType 2 def\n1 begincodespacerange\n<0000><ffff>\nendcodespacerange\n1 beginbfrange\n<0000> <' + toHex(entries.length - 1) + '> [' + entries.join(' ') + ']\nendbfrange\nendcmap\nCMapName currentdict /CMap defineresource pop\nend\nend');

      return cmap;
    }
  }]);
  return EmbeddedFont;
}(PDFFont);

var PDFFontFactory = function () {
  function PDFFontFactory() {
    classCallCheck(this, PDFFontFactory);
  }

  createClass(PDFFontFactory, null, [{
    key: 'open',
    value: function open(document, src, family, id) {
      var font = void 0;
      if (typeof src === 'string') {
        if (StandardFont.isStandardFont(src)) {
          return new StandardFont(document, src, id);
        }

        font = fontkit.openSync(src, family);
      } else if (Buffer.isBuffer(src)) {
        font = fontkit.create(src, family);
      } else if (src instanceof Uint8Array) {
        font = fontkit.create(new Buffer(src), family);
      } else if (src instanceof ArrayBuffer) {
        font = fontkit.create(new Buffer(new Uint8Array(src)), family);
      }

      if (font == null) {
        throw new Error('Not a supported font format or standard PDF font.');
      }

      return new EmbeddedFont(document, font, id);
    }
  }]);
  return PDFFontFactory;
}();

var FontsMixin = {
  initFonts: function initFonts() {
    // Lookup table for embedded fonts
    this._fontFamilies = {};
    this._fontCount = 0;

    // Font state
    this._fontSize = 12;
    this._font = null;

    this._registeredFonts = {};

    // Set the default font
    return this.font('Helvetica');
  },
  font: function font(src, family, size) {
    var cacheKey = void 0,
        font = void 0;
    if (typeof family === 'number') {
      size = family;
      family = null;
    }

    // check registered fonts if src is a string
    if (typeof src === 'string' && this._registeredFonts[src]) {
      cacheKey = src;
      var _registeredFonts$src = this._registeredFonts[src];
      src = _registeredFonts$src.src;
      family = _registeredFonts$src.family;
    } else {
      cacheKey = family || src;
      if (typeof cacheKey !== 'string') {
        cacheKey = null;
      }
    }

    if (size != null) {
      this.fontSize(size);
    }

    // fast path: check if the font is already in the PDF
    if (font = this._fontFamilies[cacheKey]) {
      this._font = font;
      return this;
    }

    // load the font
    var id = 'F' + ++this._fontCount;
    this._font = PDFFontFactory.open(this, src, family, id);

    // check for existing font familes with the same name already in the PDF
    // useful if the font was passed as a buffer
    if (font = this._fontFamilies[this._font.name]) {
      this._font = font;
      return this;
    }

    // save the font for reuse later
    if (cacheKey) {
      this._fontFamilies[cacheKey] = this._font;
    }

    if (this._font.name) {
      this._fontFamilies[this._font.name] = this._font;
    }

    return this;
  },
  fontSize: function fontSize(_fontSize) {
    this._fontSize = _fontSize;
    return this;
  },
  currentLineHeight: function currentLineHeight(includeGap) {
    if (includeGap == null) {
      includeGap = false;
    }
    return this._font.lineHeight(this._fontSize, includeGap);
  },
  registerFont: function registerFont(name, src, family) {
    this._registeredFonts[name] = {
      src: src,
      family: family
    };

    return this;
  }
};

var LineWrapper = function (_EventEmitter) {
  inherits(LineWrapper, _EventEmitter);

  function LineWrapper(document, options) {
    classCallCheck(this, LineWrapper);

    var _this = possibleConstructorReturn(this, (LineWrapper.__proto__ || Object.getPrototypeOf(LineWrapper)).call(this));

    _this.document = document;
    _this.indent = options.indent || 0;
    _this.characterSpacing = options.characterSpacing || 0;
    _this.wordSpacing = options.wordSpacing === 0;
    _this.columns = options.columns || 1;
    _this.columnGap = options.columnGap != null ? options.columnGap : 18; // 1/4 inch
    _this.lineWidth = (options.width - _this.columnGap * (_this.columns - 1)) / _this.columns;
    _this.spaceLeft = _this.lineWidth;
    _this.startX = _this.document.x;
    _this.startY = _this.document.y;
    _this.column = 1;
    _this.ellipsis = options.ellipsis;
    _this.continuedX = 0;
    _this.features = options.features;

    // calculate the maximum Y position the text can appear at
    if (options.height != null) {
      _this.height = options.height;
      _this.maxY = _this.startY + options.height;
    } else {
      _this.maxY = _this.document.page.maxY();
    }

    // handle paragraph indents
    _this.on('firstLine', function (options) {
      // if this is the first line of the text segment, and
      // we're continuing where we left off, indent that much
      // otherwise use the user specified indent option
      var indent = _this.continuedX || _this.indent;
      _this.document.x += indent;
      _this.lineWidth -= indent;

      return _this.once('line', function () {
        _this.document.x -= indent;
        _this.lineWidth += indent;
        if (options.continued && !_this.continuedX) {
          _this.continuedX = _this.indent;
        }
        if (!options.continued) {
          return _this.continuedX = 0;
        }
      });
    });

    // handle left aligning last lines of paragraphs
    _this.on('lastLine', function (options) {
      var align = options.align;

      if (align === 'justify') {
        options.align = 'left';
      }
      _this.lastLine = true;

      return _this.once('line', function () {
        _this.document.y += options.paragraphGap || 0;
        options.align = align;
        return _this.lastLine = false;
      });
    });
    return _this;
  }

  createClass(LineWrapper, [{
    key: 'wordWidth',
    value: function wordWidth(word) {
      return this.document.widthOfString(word, this) + this.characterSpacing + this.wordSpacing;
    }
  }, {
    key: 'eachWord',
    value: function eachWord(text, fn) {
      // setup a unicode line breaker
      var bk = void 0;
      var breaker = new LineBreaker(text);
      var last = null;
      var wordWidths = Object.create(null);

      while (bk = breaker.nextBreak()) {
        var shouldContinue;
        var word = text.slice((last != null ? last.position : undefined) || 0, bk.position);
        var w = wordWidths[word] != null ? wordWidths[word] : wordWidths[word] = this.wordWidth(word);

        // if the word is longer than the whole line, chop it up
        // TODO: break by grapheme clusters, not JS string characters
        if (w > this.lineWidth + this.continuedX) {
          // make some fake break objects
          var lbk = last;
          var fbk = {};

          while (word.length) {
            // fit as much of the word as possible into the space we have
            var l, mightGrow;
            if (w > this.spaceLeft) {
              // start our check at the end of our available space - this method is faster than a loop of each character and it resolves
              // an issue with long loops when processing massive words, such as a huge number of spaces
              l = Math.ceil(this.spaceLeft / (w / word.length));
              w = this.wordWidth(word.slice(0, l));
              mightGrow = w <= this.spaceLeft && l < word.length;
            } else {
              l = word.length;
            }
            var mustShrink = w > this.spaceLeft && l > 0;
            // shrink or grow word as necessary after our near-guess above
            while (mustShrink || mightGrow) {
              if (mustShrink) {
                w = this.wordWidth(word.slice(0, --l));
                mustShrink = w > this.spaceLeft && l > 0;
              } else {
                w = this.wordWidth(word.slice(0, ++l));
                mustShrink = w > this.spaceLeft && l > 0;
                mightGrow = w <= this.spaceLeft && l < word.length;
              }
            }

            // send a required break unless this is the last piece and a linebreak is not specified
            fbk.required = bk.required || l < word.length;
            shouldContinue = fn(word.slice(0, l), w, fbk, lbk);
            lbk = { required: false };

            // get the remaining piece of the word
            word = word.slice(l);
            w = this.wordWidth(word);

            if (shouldContinue === false) {
              break;
            }
          }
        } else {
          // otherwise just emit the break as it was given to us
          shouldContinue = fn(word, w, bk, last);
        }

        if (shouldContinue === false) {
          break;
        }
        last = bk;
      }
    }
  }, {
    key: 'wrap',
    value: function wrap(text, options) {
      var _this2 = this;

      // override options from previous continued fragments
      if (options.indent != null) {
        this.indent = options.indent;
      }
      if (options.characterSpacing != null) {
        this.characterSpacing = options.characterSpacing;
      }
      if (options.wordSpacing != null) {
        this.wordSpacing = options.wordSpacing;
      }
      if (options.ellipsis != null) {
        this.ellipsis = options.ellipsis;
      }

      // make sure we're actually on the page
      // and that the first line of is never by
      // itself at the bottom of a page (orphans)
      var nextY = this.document.y + this.document.currentLineHeight(true);
      if (this.document.y > this.maxY || nextY > this.maxY) {
        this.nextSection();
      }

      var buffer = '';
      var textWidth = 0;
      var wc = 0;
      var lc = 0;

      var y = this.document.y; // used to reset Y pos if options.continued (below)

      var emitLine = function emitLine() {
        options.textWidth = textWidth + _this2.wordSpacing * (wc - 1);
        options.wordCount = wc;
        options.lineWidth = _this2.lineWidth;
        y = _this2.document.y;

        _this2.emit('line', buffer, options, _this2);
        return lc++;
      };

      this.emit('sectionStart', options, this);

      this.eachWord(text, function (word, w, bk, last) {
        if (last == null || last.required) {
          _this2.emit('firstLine', options, _this2);
          _this2.spaceLeft = _this2.lineWidth;
        }

        if (w <= _this2.spaceLeft) {
          buffer += word;
          textWidth += w;
          wc++;
        }

        if (bk.required || w > _this2.spaceLeft) {
          // if the user specified a max height and an ellipsis, and is about to pass the
          // max height and max columns after the next line, append the ellipsis
          var lh = _this2.document.currentLineHeight(true);
          if (_this2.height != null && _this2.ellipsis && _this2.document.y + lh * 2 > _this2.maxY && _this2.column >= _this2.columns) {
            if (_this2.ellipsis === true) {
              _this2.ellipsis = '…';
            } // map default ellipsis character
            buffer = buffer.replace(/\s+$/, '');
            textWidth = _this2.wordWidth(buffer + _this2.ellipsis);

            // remove characters from the buffer until the ellipsis fits
            // to avoid inifinite loop need to stop while-loop if buffer is empty string
            while (buffer && textWidth > _this2.lineWidth) {
              buffer = buffer.slice(0, -1).replace(/\s+$/, '');
              textWidth = _this2.wordWidth(buffer + _this2.ellipsis);
            }
            // need to add ellipsis only if there is enough space for it
            if (textWidth <= _this2.lineWidth) {
              buffer = buffer + _this2.ellipsis;
            }

            textWidth = _this2.wordWidth(buffer);
          }

          if (bk.required) {
            if (w > _this2.spaceLeft) {
              emitLine();
              buffer = word;
              textWidth = w;
              wc = 1;
            }

            _this2.emit('lastLine', options, _this2);
          }

          emitLine();

          // if we've reached the edge of the page,
          // continue on a new page or column
          if (_this2.document.y + lh > _this2.maxY) {
            var shouldContinue = _this2.nextSection();

            // stop if we reached the maximum height
            if (!shouldContinue) {
              wc = 0;
              buffer = '';
              return false;
            }
          }

          // reset the space left and buffer
          if (bk.required) {
            _this2.spaceLeft = _this2.lineWidth;
            buffer = '';
            textWidth = 0;
            return wc = 0;
          } else {
            // reset the space left and buffer
            _this2.spaceLeft = _this2.lineWidth - w;
            buffer = word;
            textWidth = w;
            return wc = 1;
          }
        } else {
          return _this2.spaceLeft -= w;
        }
      });

      if (wc > 0) {
        this.emit('lastLine', options, this);
        emitLine();
      }

      this.emit('sectionEnd', options, this);

      // if the wrap is set to be continued, save the X position
      // to start the first line of the next segment at, and reset
      // the y position
      if (options.continued === true) {
        if (lc > 1) {
          this.continuedX = 0;
        }
        this.continuedX += options.textWidth || 0;
        return this.document.y = y;
      } else {
        return this.document.x = this.startX;
      }
    }
  }, {
    key: 'nextSection',
    value: function nextSection(options) {
      this.emit('sectionEnd', options, this);

      if (++this.column > this.columns) {
        // if a max height was specified by the user, we're done.
        // otherwise, the default is to make a new page at the bottom.
        if (this.height != null) {
          return false;
        }

        this.document.addPage();
        this.column = 1;
        this.startY = this.document.page.margins.top;
        this.maxY = this.document.page.maxY();
        this.document.x = this.startX;
        if (this.document._fillColor) {
          var _document;

          (_document = this.document).fillColor.apply(_document, toConsumableArray(this.document._fillColor || []));
        }
        this.emit('pageBreak', options, this);
      } else {
        this.document.x += this.lineWidth + this.columnGap;
        this.document.y = this.startY;
        this.emit('columnBreak', options, this);
      }

      this.emit('sectionStart', options, this);
      return true;
    }
  }]);
  return LineWrapper;
}(EventEmitter);

var number$2 = PDFObject.number;


var TextMixin = {
  initText: function initText() {
    this._line = this._line.bind(this);
    // Current coordinates
    this.x = 0;
    this.y = 0;
    return this._lineGap = 0;
  },
  lineGap: function lineGap(_lineGap) {
    this._lineGap = _lineGap;
    return this;
  },
  moveDown: function moveDown(lines) {
    if (lines == null) {
      lines = 1;
    }
    this.y += this.currentLineHeight(true) * lines + this._lineGap;
    return this;
  },
  moveUp: function moveUp(lines) {
    if (lines == null) {
      lines = 1;
    }
    this.y -= this.currentLineHeight(true) * lines + this._lineGap;
    return this;
  },
  _text: function _text(text, x, y, options, lineCallback) {
    options = this._initOptions(x, y, options);

    // Convert text to a string
    text = text == null ? '' : '' + text;

    // if the wordSpacing option is specified, remove multiple consecutive spaces
    if (options.wordSpacing) {
      text = text.replace(/\s{2,}/g, ' ');
    }

    // word wrapping
    if (options.width) {
      var wrapper = this._wrapper;
      if (!wrapper) {
        wrapper = new LineWrapper(this, options);
        wrapper.on('line', lineCallback);
      }

      this._wrapper = options.continued ? wrapper : null;
      this._textOptions = options.continued ? options : null;
      wrapper.wrap(text, options);

      // render paragraphs as single lines
    } else {
      var _iteratorNormalCompletion = true;
      var _didIteratorError = false;
      var _iteratorError = undefined;

      try {
        for (var _iterator = text.split('\n')[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
          var line = _step.value;

          lineCallback(line, options);
        }
      } catch (err) {
        _didIteratorError = true;
        _iteratorError = err;
      } finally {
        try {
          if (!_iteratorNormalCompletion && _iterator.return) {
            _iterator.return();
          }
        } finally {
          if (_didIteratorError) {
            throw _iteratorError;
          }
        }
      }
    }

    return this;
  },
  text: function text(_text2, x, y, options) {
    return this._text(_text2, x, y, options, this._line);
  },
  widthOfString: function widthOfString(string, options) {
    if (options == null) {
      options = {};
    }
    return this._font.widthOfString(string, this._fontSize, options.features) + (options.characterSpacing || 0) * (string.length - 1);
  },
  heightOfString: function heightOfString(text, options) {
    var _this = this;

    if (options == null) {
      options = {};
    }
    var x = this.x,
        y = this.y;


    options = this._initOptions(options);
    options.height = Infinity; // don't break pages

    var lineGap = options.lineGap || this._lineGap || 0;
    this._text(text, this.x, this.y, options, function (line, options) {
      return _this.y += _this.currentLineHeight(true) + lineGap;
    });

    var height = this.y - y;
    this.x = x;
    this.y = y;

    return height;
  },
  list: function list(_list, x, y, options, wrapper) {
    var _this2 = this;

    options = this._initOptions(x, y, options);

    var listType = options.listType || 'bullet';
    var unit = Math.round(this._font.ascender / 1000 * this._fontSize);
    var midLine = unit / 2;
    var r = options.bulletRadius || unit / 3;
    var indent = options.textIndent || (listType === 'bullet' ? r * 5 : unit * 2);
    var itemIndent = options.bulletIndent || (listType === 'bullet' ? r * 8 : unit * 2);

    var level = 1;
    var items = [];
    var levels = [];
    var numbers = [];

    var flatten = function flatten(list) {
      var n = 1;
      for (var _i = 0; _i < list.length; _i++) {
        var item = list[_i];
        if (Array.isArray(item)) {
          level++;
          flatten(item);
          level--;
        } else {
          items.push(item);
          levels.push(level);
          if (listType !== 'bullet') {
            numbers.push(n++);
          }
        }
      }
    };

    flatten(_list);

    var label = function label(n) {
      switch (listType) {
        case 'numbered':
          return n + '.';
        case 'lettered':
          var letter = String.fromCharCode((n - 1) % 26 + 65);
          var times = Math.floor((n - 1) / 26 + 1);
          var text = Array(times + 1).join(letter);
          return text + '.';
      }
    };

    wrapper = new LineWrapper(this, options);
    wrapper.on('line', this._line);

    level = 1;
    var i = 0;
    wrapper.on('firstLine', function () {
      var l = void 0;
      if ((l = levels[i++]) !== level) {
        var diff = itemIndent * (l - level);
        _this2.x += diff;
        wrapper.lineWidth -= diff;
        level = l;
      }

      switch (listType) {
        case 'bullet':
          _this2.circle(_this2.x - indent + r, _this2.y + midLine, r);
          return _this2.fill();
        case 'numbered':
        case 'lettered':
          var text = label(numbers[i - 1]);
          return _this2._fragment(text, _this2.x - indent, _this2.y, options);
      }
    });

    wrapper.on('sectionStart', function () {
      var pos = indent + itemIndent * (level - 1);
      _this2.x += pos;
      return wrapper.lineWidth -= pos;
    });

    wrapper.on('sectionEnd', function () {
      var pos = indent + itemIndent * (level - 1);
      _this2.x -= pos;
      return wrapper.lineWidth += pos;
    });

    wrapper.wrap(items.join('\n'), options);

    return this;
  },
  _initOptions: function _initOptions(x, y, options) {
    if (x == null) {
      x = {};
    }
    if (options == null) {
      options = {};
    }
    if ((typeof x === 'undefined' ? 'undefined' : _typeof(x)) === 'object') {
      options = x;
      x = null;
    }

    // clone options object
    options = function () {
      var opts = {};
      for (var k in options) {
        var v = options[k];
        opts[k] = v;
      }
      return opts;
    }();

    // extend options with previous values for continued text
    if (this._textOptions) {
      for (var key in this._textOptions) {
        var val = this._textOptions[key];
        if (key !== 'continued') {
          if (options[key] == null) {
            options[key] = val;
          }
        }
      }
    }

    // Update the current position
    if (x != null) {
      this.x = x;
    }
    if (y != null) {
      this.y = y;
    }

    // wrap to margins if no x or y position passed
    if (options.lineBreak !== false) {
      if (options.width == null) {
        options.width = this.page.width - this.x - this.page.margins.right;
      }
    }

    if (!options.columns) {
      options.columns = 0;
    }
    if (options.columnGap == null) {
      options.columnGap = 18;
    } // 1/4 inch

    return options;
  },
  _line: function _line(text, options, wrapper) {
    if (options == null) {
      options = {};
    }
    this._fragment(text, this.x, this.y, options);
    var lineGap = options.lineGap || this._lineGap || 0;

    if (!wrapper) {
      return this.x += this.widthOfString(text);
    } else {
      return this.y += this.currentLineHeight(true) + lineGap;
    }
  },
  _fragment: function _fragment(text, x, y, options) {
    var _this3 = this;

    var dy = void 0,
        encoded = void 0,
        i = void 0,
        positions = void 0,
        textWidth = void 0,
        words = void 0;
    text = ('' + text).replace(/\n/g, '');
    if (text.length === 0) {
      return;
    }

    // handle options
    var align = options.align || 'left';
    var wordSpacing = options.wordSpacing || 0;
    var characterSpacing = options.characterSpacing || 0;

    // text alignments
    if (options.width) {
      switch (align) {
        case 'right':
          textWidth = this.widthOfString(text.replace(/\s+$/, ''), options);
          x += options.lineWidth - textWidth;
          break;

        case 'center':
          x += options.lineWidth / 2 - options.textWidth / 2;
          break;

        case 'justify':
          // calculate the word spacing value
          words = text.trim().split(/\s+/);
          textWidth = this.widthOfString(text.replace(/\s+/g, ''), options);
          var spaceWidth = this.widthOfString(' ') + characterSpacing;
          wordSpacing = Math.max(0, (options.lineWidth - textWidth) / Math.max(1, words.length - 1) - spaceWidth);
          break;
      }
    }

    // text baseline alignments based on http://wiki.apache.org/xmlgraphics-fop/LineLayout/AlignmentHandling
    if (typeof options.baseline === 'number') {
      dy = -options.baseline;
    } else {
      switch (options.baseline) {
        case 'svg-middle':
          dy = 0.5 * this._font.xHeight;
          break;
        case 'middle':
        case 'svg-central':
          dy = 0.5 * (this._font.descender + this._font.ascender);
          break;
        case 'bottom':
        case 'ideographic':
          dy = this._font.descender;
          break;
        case 'alphabetic':
          dy = 0;
          break;
        case 'mathematical':
          dy = 0.5 * this._font.ascender;
          break;
        case 'hanging':
          dy = 0.8 * this._font.ascender;
          break;
        case 'top':
          dy = this._font.ascender;
          break;
        default:
          dy = this._font.ascender;
      }
      dy = dy / 1000 * this._fontSize;
    }

    // calculate the actual rendered width of the string after word and character spacing
    var renderedWidth = options.textWidth + wordSpacing * (options.wordCount - 1) + characterSpacing * (text.length - 1);

    // create link annotations if the link option is given
    if (options.link != null) {
      this.link(x, y, renderedWidth, this.currentLineHeight(), options.link);
    }

    // create underline or strikethrough line
    if (options.underline || options.strike) {
      this.save();
      if (!options.stroke) {
        this.strokeColor.apply(this, toConsumableArray(this._fillColor || []));
      }

      var lineWidth = this._fontSize < 10 ? 0.5 : Math.floor(this._fontSize / 10);
      this.lineWidth(lineWidth);

      var d = options.underline ? 1 : 2;
      var lineY = y + this.currentLineHeight() / d;
      if (options.underline) {
        lineY -= lineWidth;
      }

      this.moveTo(x, lineY);
      this.lineTo(x + renderedWidth, lineY);
      this.stroke();
      this.restore();
    }

    this.save();

    // oblique (angle in degrees or boolean)
    if (options.oblique) {
      var skew = void 0;
      if (typeof options.oblique === 'number') {
        skew = -Math.tan(options.oblique * Math.PI / 180);
      } else {
        skew = -0.25;
      }
      this.transform(1, 0, 0, 1, x, y);
      this.transform(1, 0, skew, 1, -skew * dy, 0);
      this.transform(1, 0, 0, 1, -x, -y);
    }

    // flip coordinate system
    this.transform(1, 0, 0, -1, 0, this.page.height);
    y = this.page.height - y - dy;

    // add current font to page if necessary
    if (this.page.fonts[this._font.id] == null) {
      this.page.fonts[this._font.id] = this._font.ref();
    }

    // begin the text object
    this.addContent('BT');

    // text position
    this.addContent('1 0 0 1 ' + number$2(x) + ' ' + number$2(y) + ' Tm');

    // font and font size
    this.addContent('/' + this._font.id + ' ' + number$2(this._fontSize) + ' Tf');

    // rendering mode
    var mode = options.fill && options.stroke ? 2 : options.stroke ? 1 : 0;
    if (mode) {
      this.addContent(mode + ' Tr');
    }

    // Character spacing
    if (characterSpacing) {
      this.addContent(number$2(characterSpacing) + ' Tc');
    }

    // Add the actual text
    // If we have a word spacing value, we need to encode each word separately
    // since the normal Tw operator only works on character code 32, which isn't
    // used for embedded fonts.
    if (wordSpacing) {
      words = text.trim().split(/\s+/);
      wordSpacing += this.widthOfString(' ') + characterSpacing;
      wordSpacing *= 1000 / this._fontSize;

      encoded = [];
      positions = [];
      var _iteratorNormalCompletion2 = true;
      var _didIteratorError2 = false;
      var _iteratorError2 = undefined;

      try {
        for (var _iterator2 = words[Symbol.iterator](), _step2; !(_iteratorNormalCompletion2 = (_step2 = _iterator2.next()).done); _iteratorNormalCompletion2 = true) {
          var _encoded, _positions;

          var word = _step2.value;

          var _font$encode = this._font.encode(word, options.features),
              _font$encode2 = slicedToArray(_font$encode, 2),
              encodedWord = _font$encode2[0],
              positionsWord = _font$encode2[1];

          (_encoded = encoded).push.apply(_encoded, toConsumableArray(encodedWord || []));
          (_positions = positions).push.apply(_positions, toConsumableArray(positionsWord || []));

          // add the word spacing to the end of the word
          // clone object because of cache
          var space = {};
          var object = positions[positions.length - 1];
          for (var key in object) {
            var val = object[key];
            space[key] = val;
          }
          space.xAdvance += wordSpacing;
          positions[positions.length - 1] = space;
        }
      } catch (err) {
        _didIteratorError2 = true;
        _iteratorError2 = err;
      } finally {
        try {
          if (!_iteratorNormalCompletion2 && _iterator2.return) {
            _iterator2.return();
          }
        } finally {
          if (_didIteratorError2) {
            throw _iteratorError2;
          }
        }
      }
    } else {
      var _font$encode3 = this._font.encode(text, options.features);

      var _font$encode4 = slicedToArray(_font$encode3, 2);

      encoded = _font$encode4[0];
      positions = _font$encode4[1];
    }

    var scale = this._fontSize / 1000;
    var commands = [];
    var last = 0;
    var hadOffset = false;

    // Adds a segment of text to the TJ command buffer
    var addSegment = function addSegment(cur) {
      if (last < cur) {
        var hex = encoded.slice(last, cur).join('');
        var advance = positions[cur - 1].xAdvance - positions[cur - 1].advanceWidth;
        commands.push('<' + hex + '> ' + number$2(-advance));
      }

      return last = cur;
    };

    // Flushes the current TJ commands to the output stream
    var flush = function flush(i) {
      addSegment(i);

      if (commands.length > 0) {
        _this3.addContent('[' + commands.join(' ') + '] TJ');
        return commands.length = 0;
      }
    };

    for (i = 0; i < positions.length; i++) {
      // If we have an x or y offset, we have to break out of the current TJ command
      // so we can move the text position.
      var pos = positions[i];
      if (pos.xOffset || pos.yOffset) {
        // Flush the current buffer
        flush(i);

        // Move the text position and flush just the current character
        this.addContent('1 0 0 1 ' + number$2(x + pos.xOffset * scale) + ' ' + number$2(y + pos.yOffset * scale) + ' Tm');
        flush(i + 1);

        hadOffset = true;
      } else {
        // If the last character had an offset, reset the text position
        if (hadOffset) {
          this.addContent('1 0 0 1 ' + number$2(x) + ' ' + number$2(y) + ' Tm');
          hadOffset = false;
        }

        // Group segments that don't have any advance adjustments
        if (pos.xAdvance - pos.advanceWidth !== 0) {
          addSegment(i + 1);
        }
      }

      x += pos.xAdvance * scale;
    }

    // Flush any remaining commands
    flush(i);

    // end the text object
    this.addContent('ET');

    // restore flipped coordinate system
    return this.restore();
  }
};

var MARKERS = [0xffc0, 0xffc1, 0xffc2, 0xffc3, 0xffc5, 0xffc6, 0xffc7, 0xffc8, 0xffc9, 0xffca, 0xffcb, 0xffcc, 0xffcd, 0xffce, 0xffcf];

var COLOR_SPACE_MAP = {
  1: 'DeviceGray',
  3: 'DeviceRGB',
  4: 'DeviceCMYK'
};

var JPEG = function () {
  function JPEG(data, label) {
    classCallCheck(this, JPEG);

    var marker = void 0;
    this.data = data;
    this.label = label;
    if (this.data.readUInt16BE(0) !== 0xffd8) {
      throw 'SOI not found in JPEG';
    }

    var pos = 2;
    while (pos < this.data.length) {
      marker = this.data.readUInt16BE(pos);
      pos += 2;
      if (MARKERS.includes(marker)) {
        break;
      }
      pos += this.data.readUInt16BE(pos);
    }

    if (!MARKERS.includes(marker)) {
      throw 'Invalid JPEG.';
    }
    pos += 2;

    this.bits = this.data[pos++];
    this.height = this.data.readUInt16BE(pos);
    pos += 2;

    this.width = this.data.readUInt16BE(pos);
    pos += 2;

    var channels = this.data[pos++];
    this.colorSpace = COLOR_SPACE_MAP[channels];

    this.obj = null;
  }

  createClass(JPEG, [{
    key: 'embed',
    value: function embed(document) {
      if (this.obj) {
        return;
      }

      this.obj = document.ref({
        Type: 'XObject',
        Subtype: 'Image',
        BitsPerComponent: this.bits,
        Width: this.width,
        Height: this.height,
        ColorSpace: this.colorSpace,
        Filter: 'DCTDecode'
      });

      // add extra decode params for CMYK images. By swapping the
      // min and max values from the default, we invert the colors. See
      // section 4.8.4 of the spec.
      if (this.colorSpace === 'DeviceCMYK') {
        this.obj.data['Decode'] = [1.0, 0.0, 1.0, 0.0, 1.0, 0.0, 1.0, 0.0];
      }

      this.obj.end(this.data);

      // free memory
      return this.data = null;
    }
  }]);
  return JPEG;
}();

var PNGImage = function () {
  function PNGImage(data, label) {
    classCallCheck(this, PNGImage);

    this.label = label;
    this.image = new PNG(data);
    this.width = this.image.width;
    this.height = this.image.height;
    this.imgData = this.image.imgData;
    this.obj = null;
  }

  createClass(PNGImage, [{
    key: 'embed',
    value: function embed(document) {
      this.document = document;
      if (this.obj) {
        return;
      }

      var hasAlphaChannel = this.image.hasAlphaChannel;

      this.obj = this.document.ref({
        Type: 'XObject',
        Subtype: 'Image',
        BitsPerComponent: hasAlphaChannel ? 8 : this.image.bits,
        Width: this.width,
        Height: this.height,
        Filter: 'FlateDecode'
      });

      if (!hasAlphaChannel) {
        var params = this.document.ref({
          Predictor: 15,
          Colors: this.image.colors,
          BitsPerComponent: this.image.bits,
          Columns: this.width
        });

        this.obj.data['DecodeParms'] = params;
        params.end();
      }

      if (this.image.palette.length === 0) {
        this.obj.data['ColorSpace'] = this.image.colorSpace;
      } else {
        // embed the color palette in the PDF as an object stream
        var palette = this.document.ref();
        palette.end(new Buffer(this.image.palette));

        // build the color space array for the image
        this.obj.data['ColorSpace'] = ['Indexed', 'DeviceRGB', this.image.palette.length / 3 - 1, palette];
      }

      // For PNG color types 0, 2 and 3, the transparency data is stored in
      // a dedicated PNG chunk.
      if (this.image.transparency.grayscale != null) {
        // Use Color Key Masking (spec section 4.8.5)
        // An array with N elements, where N is two times the number of color components.
        var val = this.image.transparency.grayscale;
        this.obj.data['Mask'] = [val, val];
      } else if (this.image.transparency.rgb) {
        // Use Color Key Masking (spec section 4.8.5)
        // An array with N elements, where N is two times the number of color components.
        var rgb = this.image.transparency.rgb;

        var mask = [];
        var _iteratorNormalCompletion = true;
        var _didIteratorError = false;
        var _iteratorError = undefined;

        try {
          for (var _iterator = rgb[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
            var x = _step.value;

            mask.push(x, x);
          }
        } catch (err) {
          _didIteratorError = true;
          _iteratorError = err;
        } finally {
          try {
            if (!_iteratorNormalCompletion && _iterator.return) {
              _iterator.return();
            }
          } finally {
            if (_didIteratorError) {
              throw _iteratorError;
            }
          }
        }

        this.obj.data['Mask'] = mask;
      } else if (this.image.transparency.indexed) {
        // Create a transparency SMask for the image based on the data
        // in the PLTE and tRNS sections. See below for details on SMasks.
        return this.loadIndexedAlphaChannel();
      } else if (hasAlphaChannel) {
        // For PNG color types 4 and 6, the transparency data is stored as a alpha
        // channel mixed in with the main image data. Separate this data out into an
        // SMask object and store it separately in the PDF.
        return this.splitAlphaChannel();
      }
      this.finalize();
    }
  }, {
    key: 'finalize',
    value: function finalize() {
      if (this.alphaChannel) {
        var sMask = this.document.ref({
          Type: 'XObject',
          Subtype: 'Image',
          Height: this.height,
          Width: this.width,
          BitsPerComponent: 8,
          Filter: 'FlateDecode',
          ColorSpace: 'DeviceGray',
          Decode: [0, 1]
        });

        sMask.end(this.alphaChannel);
        this.obj.data['SMask'] = sMask;
      }

      // add the actual image data
      this.obj.end(this.imgData);

      // free memory
      this.image = null;
      return this.imgData = null;
    }
  }, {
    key: 'splitAlphaChannel',
    value: function splitAlphaChannel() {
      var _this = this;

      return this.image.decodePixels(function (pixels) {
        var a = void 0,
            p = void 0;
        var colorCount = _this.image.colors;
        var pixelCount = _this.width * _this.height;
        var imgData = new Buffer(pixelCount * colorCount);
        var alphaChannel = new Buffer(pixelCount);

        var i = p = a = 0;
        var len = pixels.length;
        // For 16bit images copy only most significant byte (MSB) - PNG data is always stored in network byte order (MSB first)
        var skipByteCount = _this.image.bits === 16 ? 1 : 0;
        while (i < len) {
          for (var colorIndex = 0; colorIndex < colorCount; colorIndex++) {
            imgData[p++] = pixels[i++];
            i += skipByteCount;
          }
          alphaChannel[a++] = pixels[i++];
          i += skipByteCount;
        }

        _this.imgData = zlib.deflateSync(imgData);
        _this.alphaChannel = zlib.deflateSync(alphaChannel);
        return _this.finalize();
      });
    }
  }, {
    key: 'loadIndexedAlphaChannel',
    value: function loadIndexedAlphaChannel() {
      var _this2 = this;

      var transparency = this.image.transparency.indexed;
      return this.image.decodePixels(function (pixels) {
        var alphaChannel = new Buffer(_this2.width * _this2.height);

        var i = 0;
        for (var j = 0, end = pixels.length; j < end; j++) {
          alphaChannel[i++] = transparency[pixels[j]];
        }

        _this2.alphaChannel = zlib.deflateSync(alphaChannel);
        return _this2.finalize();
      });
    }
  }]);
  return PNGImage;
}();

/*
PDFImage - embeds images in PDF documents
By Devon Govett
*/

var PDFImage = function () {
  function PDFImage() {
    classCallCheck(this, PDFImage);
  }

  createClass(PDFImage, null, [{
    key: 'open',
    value: function open(src, label) {
      var data = void 0;
      if (Buffer.isBuffer(src)) {
        data = src;
      } else if (src instanceof ArrayBuffer) {
        data = new Buffer(new Uint8Array(src));
      } else {
        var match = void 0;
        if (match = /^data:.+;base64,(.*)$/.exec(src)) {
          data = new Buffer(match[1], 'base64');
        } else {
          data = fs.readFileSync(src);
          if (!data) {
            return;
          }
        }
      }

      if (data[0] === 0xff && data[1] === 0xd8) {
        return new JPEG(data, label);
      } else if (data[0] === 0x89 && data.toString('ascii', 1, 4) === 'PNG') {
        return new PNGImage(data, label);
      } else {
        throw new Error('Unknown image format.');
      }
    }
  }]);
  return PDFImage;
}();

var ImagesMixin = {
  initImages: function initImages() {
    this._imageRegistry = {};
    return this._imageCount = 0;
  },
  image: function image(src, x, y, options) {
    var bh = void 0,
        bp = void 0,
        bw = void 0,
        image = void 0,
        ip = void 0,
        left = void 0,
        left1 = void 0;
    if (options == null) {
      options = {};
    }
    if ((typeof x === 'undefined' ? 'undefined' : _typeof(x)) === 'object') {
      options = x;
      x = null;
    }

    x = (left = x != null ? x : options.x) != null ? left : this.x;
    y = (left1 = y != null ? y : options.y) != null ? left1 : this.y;

    if (typeof src === 'string') {
      image = this._imageRegistry[src];
    }

    if (!image) {
      if (src.width && src.height) {
        image = src;
      } else {
        image = this.openImage(src);
      }
    }

    if (!image.obj) {
      image.embed(this);
    }

    if (this.page.xobjects[image.label] == null) {
      this.page.xobjects[image.label] = image.obj;
    }

    var w = options.width || image.width;
    var h = options.height || image.height;

    if (options.width && !options.height) {
      var wp = w / image.width;
      w = image.width * wp;
      h = image.height * wp;
    } else if (options.height && !options.width) {
      var hp = h / image.height;
      w = image.width * hp;
      h = image.height * hp;
    } else if (options.scale) {
      w = image.width * options.scale;
      h = image.height * options.scale;
    } else if (options.fit) {
      var _options$fit = slicedToArray(options.fit, 2);

      bw = _options$fit[0];
      bh = _options$fit[1];

      bp = bw / bh;
      ip = image.width / image.height;
      if (ip > bp) {
        w = bw;
        h = bw / ip;
      } else {
        h = bh;
        w = bh * ip;
      }
    } else if (options.cover) {
      var _options$cover = slicedToArray(options.cover, 2);

      bw = _options$cover[0];
      bh = _options$cover[1];

      bp = bw / bh;
      ip = image.width / image.height;
      if (ip > bp) {
        h = bh;
        w = bh * ip;
      } else {
        w = bw;
        h = bw / ip;
      }
    }

    if (options.fit || options.cover) {
      if (options.align === 'center') {
        x = x + bw / 2 - w / 2;
      } else if (options.align === 'right') {
        x = x + bw - w;
      }

      if (options.valign === 'center') {
        y = y + bh / 2 - h / 2;
      } else if (options.valign === 'bottom') {
        y = y + bh - h;
      }
    }

    // Set the current y position to below the image if it is in the document flow
    if (this.y === y) {
      this.y += h;
    }

    this.save();
    this.transform(w, 0, 0, -h, x, y + h);
    this.addContent('/' + image.label + ' Do');
    this.restore();

    return this;
  },
  openImage: function openImage(src) {
    var image = void 0;
    if (typeof src === 'string') {
      image = this._imageRegistry[src];
    }

    if (!image) {
      image = PDFImage.open(src, 'I' + ++this._imageCount);
      if (typeof src === 'string') {
        this._imageRegistry[src] = image;
      }
    }

    return image;
  }
};

var AnnotationsMixin = {
  annotate: function annotate(x, y, w, h, options) {
    options.Type = 'Annot';
    options.Rect = this._convertRect(x, y, w, h);
    options.Border = [0, 0, 0];
    if (options.Subtype !== 'Link') {
      if (options.C == null) {
        options.C = this._normalizeColor(options.color || [0, 0, 0]);
      }
    } // convert colors
    delete options.color;

    if (typeof options.Dest === 'string') {
      options.Dest = new String(options.Dest);
    }

    // Capitalize keys
    for (var key in options) {
      var val = options[key];
      options[key[0].toUpperCase() + key.slice(1)] = val;
    }

    var ref = this.ref(options);
    this.page.annotations.push(ref);
    ref.end();
    return this;
  },
  note: function note(x, y, w, h, contents, options) {
    if (options == null) {
      options = {};
    }
    options.Subtype = 'Text';
    options.Contents = new String(contents);
    options.Name = 'Comment';
    if (options.color == null) {
      options.color = [243, 223, 92];
    }
    return this.annotate(x, y, w, h, options);
  },
  link: function link(x, y, w, h, url, options) {
    if (options == null) {
      options = {};
    }
    options.Subtype = 'Link';

    if (typeof url === 'number') {
      // Link to a page in the document (the page must already exist)
      var pages = this._root.data.Pages.data;
      if (url >= 0 && url < pages.Kids.length) {
        options.A = this.ref({
          S: 'GoTo',
          D: [pages.Kids[url], 'XYZ', null, null, null]
        });
        options.A.end();
      } else {
        throw new Error('The document has no page ' + url);
      }
    } else {
      // Link to an external url
      options.A = this.ref({
        S: 'URI',
        URI: new String(url)
      });
      options.A.end();
    }

    return this.annotate(x, y, w, h, options);
  },
  _markup: function _markup(x, y, w, h, options) {
    if (options == null) {
      options = {};
    }

    var _convertRect = this._convertRect(x, y, w, h),
        _convertRect2 = slicedToArray(_convertRect, 4),
        x1 = _convertRect2[0],
        y1 = _convertRect2[1],
        x2 = _convertRect2[2],
        y2 = _convertRect2[3];

    options.QuadPoints = [x1, y2, x2, y2, x1, y1, x2, y1];
    options.Contents = new String();
    return this.annotate(x, y, w, h, options);
  },
  highlight: function highlight(x, y, w, h, options) {
    if (options == null) {
      options = {};
    }
    options.Subtype = 'Highlight';
    if (options.color == null) {
      options.color = [241, 238, 148];
    }
    return this._markup(x, y, w, h, options);
  },
  underline: function underline(x, y, w, h, options) {
    if (options == null) {
      options = {};
    }
    options.Subtype = 'Underline';
    return this._markup(x, y, w, h, options);
  },
  strike: function strike(x, y, w, h, options) {
    if (options == null) {
      options = {};
    }
    options.Subtype = 'StrikeOut';
    return this._markup(x, y, w, h, options);
  },
  lineAnnotation: function lineAnnotation(x1, y1, x2, y2, options) {
    if (options == null) {
      options = {};
    }
    options.Subtype = 'Line';
    options.Contents = new String();
    options.L = [x1, this.page.height - y1, x2, this.page.height - y2];
    return this.annotate(x1, y1, x2, y2, options);
  },
  rectAnnotation: function rectAnnotation(x, y, w, h, options) {
    if (options == null) {
      options = {};
    }
    options.Subtype = 'Square';
    options.Contents = new String();
    return this.annotate(x, y, w, h, options);
  },
  ellipseAnnotation: function ellipseAnnotation(x, y, w, h, options) {
    if (options == null) {
      options = {};
    }
    options.Subtype = 'Circle';
    options.Contents = new String();
    return this.annotate(x, y, w, h, options);
  },
  textAnnotation: function textAnnotation(x, y, w, h, text, options) {
    if (options == null) {
      options = {};
    }
    options.Subtype = 'FreeText';
    options.Contents = new String(text);
    options.DA = new String();
    return this.annotate(x, y, w, h, options);
  },
  _convertRect: function _convertRect(x1, y1, w, h) {
    // flip y1 and y2
    var y2 = y1;
    y1 += h;

    // make x2
    var x2 = x1 + w;

    // apply current transformation matrix to points

    var _ctm = slicedToArray(this._ctm, 6),
        m0 = _ctm[0],
        m1 = _ctm[1],
        m2 = _ctm[2],
        m3 = _ctm[3],
        m4 = _ctm[4],
        m5 = _ctm[5];

    x1 = m0 * x1 + m2 * y1 + m4;
    y1 = m1 * x1 + m3 * y1 + m5;
    x2 = m0 * x2 + m2 * y2 + m4;
    y2 = m1 * x2 + m3 * y2 + m5;

    return [x1, y1, x2, y2];
  }
};

var PDFOutline = function () {
  function PDFOutline(document, parent, title, dest, options) {
    classCallCheck(this, PDFOutline);

    this.document = document;
    if (options == null) {
      options = { expanded: false };
    }
    this.options = options;
    this.outlineData = {};

    if (dest !== null) {
      this.outlineData['Dest'] = [dest.dictionary, 'Fit'];
    }

    if (parent !== null) {
      this.outlineData['Parent'] = parent;
    }

    if (title !== null) {
      this.outlineData['Title'] = new String(title);
    }

    this.dictionary = this.document.ref(this.outlineData);
    this.children = [];
  }

  createClass(PDFOutline, [{
    key: 'addItem',
    value: function addItem(title, options) {
      if (options == null) {
        options = { expanded: false };
      }
      var result = new PDFOutline(this.document, this.dictionary, title, this.document.page, options);
      this.children.push(result);

      return result;
    }
  }, {
    key: 'endOutline',
    value: function endOutline() {
      var end = void 0;
      if (this.children.length > 0) {
        var asc = void 0,
            i = void 0;
        if (this.options.expanded) {
          this.outlineData.Count = this.children.length;
        }

        var first = this.children[0],
            last = this.children[this.children.length - 1];
        this.outlineData.First = first.dictionary;
        this.outlineData.Last = last.dictionary;

        for (i = 0, end = this.children.length, asc = 0 <= end; asc ? i < end : i > end; asc ? i++ : i--) {
          var child = this.children[i];
          if (i > 0) {
            child.outlineData.Prev = this.children[i - 1].dictionary;
          }
          if (i < this.children.length - 1) {
            child.outlineData.Next = this.children[i + 1].dictionary;
          }
          child.endOutline();
        }
      }

      return this.dictionary.end();
    }
  }]);
  return PDFOutline;
}();

var OutlineMixin = {
  initOutline: function initOutline() {
    return this.outline = new PDFOutline(this, null, null, null);
  },
  endOutline: function endOutline() {
    this.outline.endOutline();
    if (this.outline.children.length > 0) {
      this._root.data.Outlines = this.outline.dictionary;
      return this._root.data.PageMode = 'UseOutlines';
    }
  }
};

/*
PDFDocument - represents an entire PDF document
By Devon Govett
*/

var PDFDocument = function (_stream$Readable) {
  inherits(PDFDocument, _stream$Readable);

  function PDFDocument() {
    var options = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};
    classCallCheck(this, PDFDocument);

    var _this = possibleConstructorReturn(this, (PDFDocument.__proto__ || Object.getPrototypeOf(PDFDocument)).call(this, options));

    _this.options = options;

    // PDF version
    switch (options.pdfVersion) {
      case '1.4':
        _this.version = 1.4;
        break;
      case '1.5':
        _this.version = 1.5;
        break;
      case '1.6':
        _this.version = 1.6;
        break;
      case '1.7':
      case '1.7ext3':
        _this.version = 1.7;
        break;
      default:
        _this.version = 1.3;
        break;
    }

    // Whether streams should be compressed
    _this.compress = _this.options.compress != null ? _this.options.compress : true;

    _this._pageBuffer = [];
    _this._pageBufferStart = 0;

    // The PDF object store
    _this._offsets = [];
    _this._waiting = 0;
    _this._ended = false;
    _this._offset = 0;
    var Pages = _this.ref({
      Type: 'Pages',
      Count: 0,
      Kids: []
    });

    Pages.finalize = function () {
      this.offset = this.document._offset;
      this.document._write(this.id + ' ' + this.gen + ' obj');
      this.document._write('<<');
      this.document._write('/Type /Pages');
      this.document._write('/Count ' + this.data.Count);
      this.document._write('/Kids [' + Buffer.concat(this.data.Kids).slice(0, -1).toString() + ']');
      this.document._write('>>');
      this.document._write('endobj');
      return this.document._refEnd(this);
    };

    _this._root = _this.ref({
      Type: 'Catalog',
      Pages: Pages
    });

    // The current page
    _this.page = null;

    // Initialize mixins
    _this.initColor();
    _this.initVector();
    _this.initFonts();
    _this.initText();
    _this.initImages();
    _this.initOutline();

    // Initialize the metadata
    _this.info = {
      Producer: 'PDFKit',
      Creator: 'PDFKit',
      CreationDate: new Date()
    };

    if (_this.options.info) {
      for (var key in _this.options.info) {
        var val = _this.options.info[key];
        _this.info[key] = val;
      }
    }

    // Generate file ID
    _this._id = PDFSecurity.generateFileID(_this.info);

    // Initialize security settings
    _this._security = PDFSecurity.create(_this, options);

    // Write the header
    // PDF version
    _this._write('%PDF-' + _this.version);

    // 4 binary chars, as recommended by the spec
    _this._write('%\xFF\xFF\xFF\xFF');

    // Add the first page
    if (_this.options.autoFirstPage !== false) {
      _this.addPage();
    }
    return _this;
  }

  createClass(PDFDocument, [{
    key: 'addPage',
    value: function addPage(options) {
      // end the current page if needed
      if (options == null) {
        options = this.options;
      }
      if (!this.options.bufferPages) {
        this.flushPages();
      }

      // create a page object
      this.page = new PDFPage(this, options);
      this._pageBuffer.push(this.page);

      // add the page to the object store
      var pages = this._root.data.Pages.data;
      pages.Kids.push(new Buffer(this.page.dictionary + ' '));
      pages.Count++;

      // reset x and y coordinates
      this.x = this.page.margins.left;
      this.y = this.page.margins.top;

      // flip PDF coordinate system so that the origin is in
      // the top left rather than the bottom left
      this._ctm = [1, 0, 0, 1, 0, 0];
      this.transform(1, 0, 0, -1, 0, this.page.height);

      this.emit('pageAdded');

      return this;
    }
  }, {
    key: 'bufferedPageRange',
    value: function bufferedPageRange() {
      return { start: this._pageBufferStart, count: this._pageBuffer.length };
    }
  }, {
    key: 'switchToPage',
    value: function switchToPage(n) {
      var page = void 0;
      if (!(page = this._pageBuffer[n - this._pageBufferStart])) {
        throw new Error('switchToPage(' + n + ') out of bounds, current buffer covers pages ' + this._pageBufferStart + ' to ' + (this._pageBufferStart + this._pageBuffer.length - 1));
      }

      return this.page = page;
    }
  }, {
    key: 'flushPages',
    value: function flushPages() {
      // this local variable exists so we're future-proof against
      // reentrant calls to flushPages.
      var pages = this._pageBuffer;
      this._pageBuffer = [];
      this._pageBufferStart += pages.length;
      var _iteratorNormalCompletion = true;
      var _didIteratorError = false;
      var _iteratorError = undefined;

      try {
        for (var _iterator = pages[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
          var page = _step.value;

          page.end();
        }
      } catch (err) {
        _didIteratorError = true;
        _iteratorError = err;
      } finally {
        try {
          if (!_iteratorNormalCompletion && _iterator.return) {
            _iterator.return();
          }
        } finally {
          if (_didIteratorError) {
            throw _iteratorError;
          }
        }
      }
    }
  }, {
    key: 'ref',
    value: function ref(data) {
      var ref = new PDFReference(this, this._offsets.length + 1, data);
      this._offsets.push(null); // placeholder for this object's offset once it is finalized
      this._waiting++;
      return ref;
    }
  }, {
    key: '_read',
    value: function _read() {}
    // do nothing, but this method is required by node

  }, {
    key: '_write',
    value: function _write(data) {
      if (!Buffer.isBuffer(data)) {
        data = new Buffer(data + '\n', 'binary');
      }

      this.push(data);
      return this._offset += data.length;
    }
  }, {
    key: 'addContent',
    value: function addContent(data) {
      this.page.write(data);
      return this;
    }
  }, {
    key: '_refEnd',
    value: function _refEnd(ref) {
      this._offsets[ref.id - 1] = ref.offset;
      if (--this._waiting === 0 && this._ended) {
        this._finalize();
        return this._ended = false;
      }
    }
  }, {
    key: 'write',
    value: function write(filename, fn) {
      // print a deprecation warning with a stacktrace
      var err = new Error('PDFDocument#write is deprecated, and will be removed in a future version of PDFKit. Please pipe the document into a Node stream.');

      console.warn(err.stack);

      this.pipe(fs.createWriteStream(filename));
      this.end();
      return this.once('end', fn);
    }
  }, {
    key: 'output',
    value: function output(fn) {
      // more difficult to support this. It would involve concatenating all the buffers together
      throw new Error('PDFDocument#output is deprecated, and has been removed from PDFKit. Please pipe the document into a Node stream.');
    }
  }, {
    key: 'end',
    value: function end() {
      this.flushPages();
      this._info = this.ref();
      for (var key in this.info) {
        var val = this.info[key];
        if (typeof val === 'string') {
          val = new String(val);
        }

        var entry = this.ref(val);
        entry.end();

        this._info.data[key] = entry;
      }

      this._info.end();

      for (var name in this._fontFamilies) {
        var font = this._fontFamilies[name];
        font.finalize();
      }

      this.endOutline();

      this._root.end();
      this._root.data.Pages.end();

      if (this._security) {
        this._security.end();
      }

      if (this._waiting === 0) {
        return this._finalize();
      } else {
        return this._ended = true;
      }
    }
  }, {
    key: '_finalize',
    value: function _finalize(fn) {
      // generate xref
      var xRefOffset = this._offset;
      this._write('xref');
      this._write('0 ' + (this._offsets.length + 1));
      this._write('0000000000 65535 f ');

      var _iteratorNormalCompletion2 = true;
      var _didIteratorError2 = false;
      var _iteratorError2 = undefined;

      try {
        for (var _iterator2 = this._offsets[Symbol.iterator](), _step2; !(_iteratorNormalCompletion2 = (_step2 = _iterator2.next()).done); _iteratorNormalCompletion2 = true) {
          var offset = _step2.value;

          offset = ('0000000000' + offset).slice(-10);
          this._write(offset + ' 00000 n ');
        }

        // trailer
      } catch (err) {
        _didIteratorError2 = true;
        _iteratorError2 = err;
      } finally {
        try {
          if (!_iteratorNormalCompletion2 && _iterator2.return) {
            _iterator2.return();
          }
        } finally {
          if (_didIteratorError2) {
            throw _iteratorError2;
          }
        }
      }

      var trailer = {
        Size: this._offsets.length + 1,
        Root: this._root,
        Info: this._info,
        ID: [this._id, this._id]
      };
      if (this._security) {
        trailer.Encrypt = this._security.dictionary;
      }

      this._write('trailer');
      this._write(PDFObject.convert(trailer));

      this._write('startxref');
      this._write('' + xRefOffset);
      this._write('%%EOF');

      // end the stream
      return this.push(null);
    }
  }, {
    key: 'toString',
    value: function toString() {
      return '[object PDFDocument]';
    }
  }]);
  return PDFDocument;
}(stream.Readable);

var mixin = function mixin(methods) {
  Object.assign(PDFDocument.prototype, methods);
};

mixin(ColorMixin);
mixin(VectorMixin);
mixin(FontsMixin);
mixin(TextMixin);
mixin(ImagesMixin);
mixin(AnnotationsMixin);
mixin(OutlineMixin);

export default PDFDocument;
//# sourceMappingURL=pdfkit.es5.js.map
