export const BackButton = {
  mounted() {
    this.el.addEventListener("click", () => {
      history.back()
    })
  }
}
