;; Event Coordination Contract
;; Manages equipment availability for competitions

(define-data-var last-id uint u0)

(define-map events
  { id: uint }
  {
    name: (string-ascii 100),
    location: (string-ascii 100),
    start-date: uint,
    end-date: uint,
    sport: (string-ascii 50),
    organizer: principal,
    status: (string-ascii 20)
  }
)

(define-map event-equipment
  { event-id: uint, equipment-id: uint }
  {
    reserved: bool,
    athlete: (optional principal)
  }
)

;; Create event
(define-public (create-event
    (name (string-ascii 100))
    (location (string-ascii 100))
    (start-date uint)
    (end-date uint)
    (sport (string-ascii 50))
  )
  (let
    (
      (new-id (+ (var-get last-id) u1))
    )
    (var-set last-id new-id)

    (map-set events
      { id: new-id }
      {
        name: name,
        location: location,
        start-date: start-date,
        end-date: end-date,
        sport: sport,
        organizer: tx-sender,
        status: "upcoming"
      }
    )

    (ok new-id)
  )
)

;; Reserve equipment for event
(define-public (reserve-equipment
    (event-id uint)
    (equipment-id uint)
  )
  (let
    (
      (event (unwrap! (map-get? events { id: event-id }) (err u404)))
    )

    (map-set event-equipment
      { event-id: event-id, equipment-id: equipment-id }
      {
        reserved: true,
        athlete: none
      }
    )

    (ok true)
  )
)

;; Assign equipment to athlete for event
(define-public (assign-equipment
    (event-id uint)
    (equipment-id uint)
    (athlete principal)
  )
  (let
    (
      (reservation (unwrap! (map-get? event-equipment { event-id: event-id, equipment-id: equipment-id }) (err u404)))
    )
    (asserts! (get reserved reservation) (err u400))

    (map-set event-equipment
      { event-id: event-id, equipment-id: equipment-id }
      {
        reserved: true,
        athlete: (some athlete)
      }
    )

    (ok true)
  )
)

;; Get event
(define-read-only (get-event (id uint))
  (map-get? events { id: id })
)

;; Get event equipment
(define-read-only (get-event-equipment (event-id uint) (equipment-id uint))
  (map-get? event-equipment { event-id: event-id, equipment-id: equipment-id })
)
