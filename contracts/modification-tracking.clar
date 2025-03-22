;; Modification Tracking Contract
;; Documents customizations for specific needs

(define-data-var last-id uint u0)

(define-map modifications
  { id: uint }
  {
    equipment-id: uint,
    description: (string-ascii 200),
    technician: principal,
    date: uint,
    athlete-needs: (string-ascii 200),
    status: (string-ascii 20)
  }
)

;; Record modification
(define-public (record-modification
    (equipment-id uint)
    (description (string-ascii 200))
    (athlete-needs (string-ascii 200))
  )
  (let
    (
      (new-id (+ (var-get last-id) u1))
    )
    (var-set last-id new-id)

    (map-set modifications
      { id: new-id }
      {
        equipment-id: equipment-id,
        description: description,
        technician: tx-sender,
        date: block-height,
        athlete-needs: athlete-needs,
        status: "in-progress"
      }
    )

    (ok new-id)
  )
)

;; Complete modification
(define-public (complete-modification
    (modification-id uint)
  )
  (let
    (
      (modification (unwrap! (map-get? modifications { id: modification-id }) (err u404)))
    )
    (asserts! (is-eq tx-sender (get technician modification)) (err u403))

    (map-set modifications
      { id: modification-id }
      (merge modification { status: "completed" })
    )

    (ok true)
  )
)

;; Get modification
(define-read-only (get-modification (id uint))
  (map-get? modifications { id: id })
)
