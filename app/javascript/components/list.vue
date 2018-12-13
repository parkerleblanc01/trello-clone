<template>
  <div class="list">
    <div class="list-title">
      <h6>{{ list.name }}</h6><a v-on:click="deleteList" class="right">Delete</a>
    </div>

    <draggable v-model="list.cards" :options="{group: 'cards'}" class="dragArea" @change="cardMoved">
      <card v-for="card in list.cards" :key="card.id" :card="card" :list="list"></card>
    </draggable>

    <a v-if="!editing" v-on:click="startEditing">Add a card</a>
    <textarea v-if="editing" ref="message" v-model="message" class="form-control mb-1"></textarea>
    <button v-if="editing" v-on:click="createCard" class="btn btn-secondary">Add</button>
    <a v-if="editing" v-on:click="editing=false">Cancel</a>
  </div>
</template>

<script>
import draggable from 'vuedraggable'
import card from 'components/card'

export default{
  components: { draggable, card },
  props: ["list"],

  data: function() {
    return {
      editing: false,
      message: ""
    }
  },

  methods: {
    startEditing: function(){
      this.editing = true
      this.$nextTick(() => { this.$refs.message.focus() })
    },

    cardMoved: function(event) {
      const evt = event.added || event.moved
      if (evt == undefined) { return }

      const element = evt.element
      const list_index = window.store.state.lists.findIndex((list) => {
        return list.cards.find((card) => {
          return card.id === element.id
        })
      })

      var data = new FormData
      data.append("card[list_id]", window.store.state.lists[list_index].id)
      data.append("card[position]", evt.newIndex + 1)

      Rails.ajax({
        beforeSend: () => true,
        url: `/cards/${element.id}/move`,
        type: "PATCH",
        data: data,
        dataType: "json",
      })
    },

    createCard: function() {
      var data = new FormData
      data.append("card[list_id]", this.list.id)
      data.append("card[name]", this.message)

      Rails.ajax({
        url: "/cards",
        type: "POST",
        data: data,
        dataType: "json",
        success: (data) => {
          //this.$store.commit('addCard', data)
          this.message = ""
          this.$nextTick(() => { this.$refs.message.focus() })
        },
        beforeSend: function() {return true}
      })
    },

    deleteList: function() {
      this.$swal({
        title: "Delete this list?",
        text: "Are you sure? You'll lose all the cards in this list!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        confirmButtonText: "Yes, Delete it!"
      }).then((isConfirmed) => {
        if(isConfirmed.value){
          Rails.ajax({
            url: `/lists/${this.list.id}`,
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
h6 {
  display: inline;
}
.list-title{
  padding-bottom: 10px;
}
.dragArea {
  min-height: 20px;
}
.right{
  float: right;
}
</style>
