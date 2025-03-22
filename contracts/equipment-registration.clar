;; Equipment Registration Contract
;; Records details of specialized sports gear

(define-data-var last-id uint u0)

(define-map equipment
  { id: uint }
  {
    name: (string-ascii 100),
    type: (string-ascii 50),
    sport: (string-ascii 50),
    description: (string-ascii 200),
    owner: principal,
    available: bool
  }
)

;; Register equipment
(define-public (register
    (name (string-ascii 100))
    (type (string-ascii 50))
    (sport (string-ascii 50))
    (description (string-ascii 200))
  )
  (let
    (
      (new-id (+ (var-get last-id) u1))
    )
    (var-set last-id new-id)

    (map-set equipment
      { id: new-id }
      {
        name: name,
        type: type,
        sport: sport,
        description: description,
        owner: tx-sender,
        available: true
      }
    )

    (ok new-id)
  )
)

;; Update availability
(define-public (update-availability
    (equipment-id uint)
    (available bool)
  )
  (let
    (
      (item (unwrap! (map-get? equipment { id: equipment-id }) (err u404)))
    )
    (asserts! (is-eq tx-sender (get owner item)) (err u403))

    (map-set equipment
      { id: equipment-id }
      (merge item { available: available })
    )

    (ok true)
  )
)

;; Get equipment
(define-read-only (get-equipment (id uint))
  (map-get? equipment { id: id })
)
