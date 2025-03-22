;; Athlete Matching Contract
;; Connects equipment with appropriate users

(define-data-var last-id uint u0)

(define-map requests
  { id: uint }
  {
    athlete: principal,
    equipment-type: (string-ascii 50),
    sport: (string-ascii 50),
    needs: (string-ascii 200),
    equipment-id: (optional uint),
    status: (string-ascii 20)
  }
)

;; Request equipment
(define-public (request-equipment
    (equipment-type (string-ascii 50))
    (sport (string-ascii 50))
    (needs (string-ascii 200))
  )
  (let
    (
      (new-id (+ (var-get last-id) u1))
    )
    (var-set last-id new-id)

    (map-set requests
      { id: new-id }
      {
        athlete: tx-sender,
        equipment-type: equipment-type,
        sport: sport,
        needs: needs,
        equipment-id: none,
        status: "pending"
      }
    )

    (ok new-id)
  )
)

;; Match equipment
(define-public (match-equipment
    (request-id uint)
    (equipment-id uint)
  )
  (let
    (
      (request (unwrap! (map-get? requests { id: request-id }) (err u404)))
    )

    (map-set requests
      { id: request-id }
      (merge request {
        equipment-id: (some equipment-id),
        status: "matched"
      })
    )

    (ok true)
  )
)

;; Get request
(define-read-only (get-request (id uint))
  (map-get? requests { id: id })
)
