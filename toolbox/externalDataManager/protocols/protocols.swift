//
//  protocols.swift
//  toolbox
//
//  Created by Cesar Guasca on 12/07/21.
//

import Foundation
protocol ListenerGetToken {
    func successGetToken(_ response : Auth)
    func failureGetToken(_ loginError : String)
}
protocol ListenerGetCarrousell {
    func successGetCarrousell(_ response : [Carrousell])
    func failureGetCarrousell(_ loginError : String)
}
