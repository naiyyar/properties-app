### setting up coliving number form 5 to 9
# step1: Price.where(bed_type: 5).update_all(bed_type: 9)

# step2: RentMedian.where(bed_type: 5).update_all(bed_type: 9)

# step3: Price and RentMedian form changes