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

;; Invite a collaborator
(define-public (invite-collaborator (composition-id uint) (collaborator principal) (share-percentage uint))
  (let
    (
      (composition (unwrap! (map-get? compositions { composition-id: composition-id }) (err u404)))
    )
    (asserts! (is-eq tx-sender (get owner composition)) err-not-token-owner)
    (asserts! (<= share-percentage (get royalty-percentage composition)) err-invalid-collaboration)
    (map-set collaborations
      { composition-id: composition-id, collaborator: collaborator }
      { accepted: false, share-percentage: share-percentage }
    )
    (ok true)
  )
)

;; Accept collaboration invitation
(define-public (accept-collaboration (composition-id uint))
  (let
    (
      (collaboration (unwrap! (map-get? collaborations { composition-id: composition-id, collaborator: tx-sender }) (err u404)))
      (composition (unwrap! (map-get? compositions { composition-id: composition-id }) (err u404)))
    )
    (asserts! (not (get accepted collaboration)) err-invalid-collaboration)
    (map-set collaborations
      { composition-id: composition-id, collaborator: tx-sender }
      (merge collaboration { accepted: true })
    )
    (map-set compositions
      { composition-id: composition-id }
      (merge composition { collaborators: (unwrap! (as-max-len? (append (get collaborators composition) tx-sender) u5) err-invalid-collaboration) })
    )
    (ok true)
  )
)

;; Get composition details
(define-read-only (get-composition (composition-id uint))
  (map-get? compositions { composition-id: composition-id })
)

;; Get collaboration details
(define-read-only (get-collaboration (composition-id uint) (collaborator principal))
  (map-get? collaborations { composition-id: composition-id, collaborator: collaborator })
)