<template>
  <div>
    <div @click="editing=true" class="card card-body mb-3">
      {{ card.name }}
    </div>

    <div v-if='editing' class="modal-backdrop show"></div>

    <div v-if='editing' @click="closeModel" class="modal show" style="display: block">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">{{ card.name }}</h5><a v-on:click="deleteCard" class="right">Delete</a>
          </div>
          <div class="modal-body">
            <input v-model="name" class="form-control"></input>
          </div>
          <div class="modal-footer">
            <button @click="save" type="button" class="btn btn-primary">Save changes</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  export default{
    props: ['card', 'list'],
    data: function() {
      return {
        editing: false,
        name: this.card.name
      }
    },

    methods: {
      closeModel: function(event) {
        if(event.target.classList.contains("modal")){
          this.editing = false
        }
      },

      save: function() {
        var data = new FormData
        data.append("card[name]", this.name)

        Rails.ajax({
          url: `/cards/${this.card.id}`,
          type: "PATCH",
          data: data,
          dataType: "json",
          success: (data) => {
            //this.$store.commit('editCard', data)
            this.editing = false
          },
          beforeSend: function() {return true}
        })
      },

      deleteCard: function() {
        this.$swal({
          title: "Delete this card?",
          text: "Are you sure? You can't turn back!",
          type: "warning",
          showCancelButton: true,
          confirmButtonColor: "#3085d6",
          confirmButtonText: "Yes, Delete it!"
        }).then((isConfirmed) => {
          if(isConfirmed.value){
            Rails.ajax({
              url: `/cards/${this.card.id}`,
              type: "DELETE",
              dataType: "json",
              beforeSend: function() {return true}
            })
          }
        })
      }
    }
  }
</script>

<style scoped>
</style>
