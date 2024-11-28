;; harmony-chain.clar

;; Define constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-token-owner (err u101))
(define-constant err-invalid-collaboration (err u102))

;; Define data variables
(define-data-var next-composition-id uint u0)

;; Define data maps
(define-map compositions
  { composition-id: uint }
  {
    owner: principal,
    title: (string-ascii 50),
    ipfs-hash: (string-ascii 46),
    collaborators: (list 5 principal),
    royalty-percentage: uint
  }
)

(define-map collaborations
  { composition-id: uint, collaborator: principal }
  { accepted: bool, share-percentage: uint }
)

;; Define NFT token
(define-non-fungible-token composition uint)

;; Create a new composition
(define-public (create-composition (title (string-ascii 50)) (ipfs-hash (string-ascii 46)) (royalty-percentage uint))
  (let
    (
      (composition-id (var-get next-composition-id))
    )
    (try! (nft-mint? composition composition-id tx-sender))
    (map-set compositions
      { composition-id: composition-id }
      {
        owner: tx-sender,
        title: title,
        ipfs-hash: ipfs-hash,
        collaborators: (list),
        royalty-percentage: royalty-percentage
      }
    )
    (var-set next-composition-id (+ composition-id u1))
    (ok composition-id)
  )
)