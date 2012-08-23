import QtQuick 1.1
import com.nokia.meego 1.0


XmlListModel {
    property string personCode

    source: "http://api.allocine.fr/rest/v3/person?partner=" + partner + "&profile=large&code=" + personCode + "&format=xml   "
    query: "/person"
    namespaceDeclarations: "declare default element namespace 'http://www.allocine.net/v6/ns/';"

    XmlRole { name: "givenName"; query: "name/@given/string()" }
    XmlRole { name: "gender"; query: "gender/number()" }
    XmlRole { name: "familyName"; query: "name/@family/string()" }
    XmlRole { name: "activityShort"; query: "activityShort/string()" }
    XmlRole { name: "biographyShort"; query: "biographyShort/string()" }
    XmlRole { name: "biography"; query: "biography/string()" }
    XmlRole { name: "birthDate"; query: "birthDate/string()" }
    XmlRole { name: "birthPlace"; query: "birthPlace/string()" }
    XmlRole { name: "picture"; query: "picture/@href/string()" }

}
