setVar('items', []);
addLibrary('FlxText', 'flixel.text');
addLibrary('Reflect');

function newItem(tag, item){
    getVar('items')[tag] = item;
}

function getObject(tag){
    return getVar('items')[tag];
}

function addItem(tag){
    game.add(getObject(tag));
}

function newSprite(tag, path, x, y){
    newItem(tag, new FlxSprite(x, y).loadGraphic(Paths.image(path)));
}

function newText(tag, text, width, x, y, size){
    newItem(tag, new FlxText(x, y, width, text, size));
}

function getField(object, fieldString, ?i){
    i = if (i != null) i else 0;
    var splittedField = fieldString.split('.');
    var returnThis;
    if (i != splittedField.length-1)
        returnThis = getField(Reflect.getProperty(object, splittedField[i]), fieldString, i+1);
    else
        returnThis = Reflect.getProperty(object, splittedField[i]);
}

function setProperty(fullObject, value){
    var splittedString = fullObject.split('.');
    var object = splittedString[0];
    var field = splittedString[splittedString.length-1];

    if (splittedString.length > 1){
        var fieldLoop = fullObject.substr(object.length).substr(1, -field.length-2);
        Reflect.setProperty(getField(getObject(object), fieldLoop), field, value);
    }else{
        Reflect.setProperty(getObject(object), field, value);
    }
    return true;
}

function getProperty(me){
    var splittedString = me.split('.');
    var object = splittedString[0];
    var field = splittedString[splittedString.length-1];
    var returnedProperty;

    if (splittedString.length > 1){
        var fieldLoop = me.substr(object.length).substr(1, -field.length-2);
        returnedProperty = Reflect.getProperty(getField(getObject(object), fieldLoop), field);
    }else{
        returnedProperty = Reflect.getProperty(getObject(object), field);
    }
    return returnedProperty;
}

/*function create(){
    trace('seperator!');
    newSprite('test', 'Bottom', 500, 0);
    addItem('test');
    setProperty('test.velocity.x', 300);
}*/

// stuff i made that is going to be used in the future ignore this for now
