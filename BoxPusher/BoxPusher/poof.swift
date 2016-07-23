// ---------------------------------------
// Sprite definitions for 'poof'
// Generated with TexturePacker 4.2.2
//
// http://www.codeandweb.com/texturepacker
// ---------------------------------------

import SpriteKit


class poof {

    // sprite names
    let POOF1 = "poof1"
    let POOF2 = "poof2"
    let POOF3 = "poof3"
    let POOF4 = "poof4"
    let POOF5 = "poof5"
    let POOF6 = "poof6"


    // load texture atlas
    let textureAtlas = SKTextureAtlas(named: "poof")


    // individual texture objects
    func poof1() -> SKTexture { return textureAtlas.textureNamed(POOF1) }
    func poof2() -> SKTexture { return textureAtlas.textureNamed(POOF2) }
    func poof3() -> SKTexture { return textureAtlas.textureNamed(POOF3) }
    func poof4() -> SKTexture { return textureAtlas.textureNamed(POOF4) }
    func poof5() -> SKTexture { return textureAtlas.textureNamed(POOF5) }
    func poof6() -> SKTexture { return textureAtlas.textureNamed(POOF6) }


    // texture arrays for animations
    func poof() -> [SKTexture] {
        return [
            poof1(),
            poof2(),
            poof3(),
            poof4(),
            poof5(),
            poof6()
        ]
    }


}
